#include "../global.hpp"
#include "Memory.hpp"

Memory::Memory() {}

Memory::~Memory() {}

bool is_local_val(Entry e)
{
    return e.type == ENTRY_TYPES::ARGUMENT | e.type == ENTRY_TYPES::LOCAL_VAR;
}

void Memory::set_scope(SCOPE scope)
{
    this->scope = scope;
    this->reset_scope();
}
SCOPE Memory::get_scope()
{
    return this->scope;
}

void Memory::reset_scope()
{
    this->bp_up = 0;
    this->bp_dn = 0;
    this->func_buffer = std::stringstream("");

    std::vector<int> ids_to_delete = std::vector<int>();
    for (Entry e : this->table)
    {
        if (is_local_val(e))
            ids_to_delete.push_back(e.mem_index);
    }

    auto revit = ids_to_delete.rbegin();
    for (; revit != ids_to_delete.rend(); revit++)
    {
        this->table.erase(this->table.begin() + *revit);
    }
    int b = 1;
    // reindex after reset.
    for (size_t i = 0; i < this->table.size(); i++)
    {
        auto e = &(this->table[i]);
        e->mem_index = i;
    }
    int a = 1;
}
void Memory::initial_bp(bool has_return_var)
{
    if (has_return_var)
    {
        this->bp_dn = 0;
        this->bp_up = 12;
    }
    else
    {
        this->bp_dn = 0;
        this->bp_up = 8;
    }
}

fort::char_table Memory::dump()
{
    fort::char_table out;
    out << fort::header << "ENTRY_TYPE"
        << "name_or_value"
        << "address"
        << "mem_index"
        << "STD_TYPE" << fort::endr;
    for (auto e : this->table)
    {
        out << enum2str(e.type) << e.name_or_value << e.get_asm_var() << e.mem_index << enum2str(e.vartype) << fort::endr;
    }
    return out;
}

int Memory::add_entry(Entry e)
{
    size_t index = this->table.size();
    e.mem_index = index;
    this->table.push_back(e);
    return index;
}

Entry Memory::add_temp_var(STD_TYPES type)
{

    Entry e = Entry();
    if (this->scope == SCOPE::LOCAL)
        e.type = ENTRY_TYPES::LOCAL_VAR;
    else
        e.type = ENTRY_TYPES::VAR;
    e.vartype = type;
    e.name_or_value = std::string("$t") + std::to_string(this->temp_var_count);
    this->temp_var_count += 1;
    int i = this->add_entry(e);
    e.mem_index = i;
    this->allocate(i);

    return this->table[i];
}

void Memory::allocate(int id)
{
    auto e = &(this->table[id]);
    e->mem_index = id;
    if (e->type == ENTRY_TYPES::VAR)
    {
        e->address = this->address_pointer;
        switch (e->vartype)
        {
        case STD_TYPES::INTEGER:
            this->address_pointer += 4;
            break;
        case STD_TYPES::REAL:
            this->address_pointer += 8;
            break;
        }
    }
    else if (e->type == ENTRY_TYPES::LOCAL_VAR)
    {
        switch (e->vartype)
        {
        case STD_TYPES::INTEGER:
            this->bp_dn -= 4;
            break;
        case STD_TYPES::REAL:
            this->bp_dn -= 8;
            break;
        }
        e->address = this->bp_dn;
    }
    else if (e->type == ENTRY_TYPES::ARGUMENT)
    {
        e->address = this->bp_up;
        switch (e->vartype)
        {
        case STD_TYPES::INTEGER:
            this->bp_up += 4;
            break;
        case STD_TYPES::REAL:
            this->bp_up += 8;
            break;
        }
    }
    else
    {
        // Capture all not variables and skip if not debugging.
        BREAKPOINT;
        return;
    }
}

Entry Memory::get(std::string id)
{
    // Search local scope first, then global.
    for (auto a : this->table)
    {
        if (is_local_val(a) && a.name_or_value == id)
        {
            return a;
        }
    }

    for (size_t i = 0; i < this->table.size(); i++)
    {
        auto a = this->table[i];
        if (a.name_or_value == id)
        {
            return a;
        }
    }
    BREAKPOINT;
    return Entry();
}
bool Memory::exists(std::string id)
{
    if (this->scope == SCOPE::GLOBAL)
    {
        for (size_t i = 0; i < this->table.size(); i++)
        {
            auto a = this->table[i];
            if (a.name_or_value == id)
            {
                return true;
            }
        }
        return false;
    }
    else
    {
        //Search local scope
        for (auto a : this->table)
        {
            if (is_local_val(a) && a.name_or_value == id)
            {
                return true;
            }
        }
        return false;
    }
}
void Memory::update_entry(int index, Entry e)
{
    this->table[index] = e;
}

Entry Memory::operator[](int index)
{
    return this->table[index];
}
void Memory::operator<<(std::string a)
{
    if (this->scope == SCOPE::GLOBAL)
    {
        outfile << a;
    }
    else
    {
        this->func_buffer << a;
    }
}
std::string Memory::func_body()
{
    return this->func_buffer.str();
}
int Memory::local_temp_bytes()
{
    return this->bp_dn * -1;
}