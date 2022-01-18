#include "../global.hpp"
#include "Memory.hpp"

Memory::Memory() {}

Memory::~Memory() {}

void Memory::set_scope(SCOPE scope)
{
    this->scope = scope;
}

fort::char_table Memory::dump()
{
    std::cout << "MEMORY: " << std::endl;
    fort::char_table out;
    out << fort::header << "ENTRY_TYPE"
        << "name_or_value"
        << "address"
        << "mem_index"
        << "STD_TYPE" << fort::endr;
    for (auto e : this->table)
    {
        out << enum2str(e.type) << e.name_or_value << e.address << e.mem_index << enum2str(e.vartype) << fort::endr;
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
    e.type = ENTRY_TYPES::VAR;
    e.vartype = type;
    e.name_or_value = std::string("$t") + std::to_string(this->temp_var_count);
    this->temp_var_count += 1;
    int i = this->add_entry(e);
    e.mem_index = i;
    this->allocate(i);

    return e;
}

void Memory::allocate(int id)
{
    auto e = this->table[id];
    e.mem_index = id;
    if (e.type == ENTRY_TYPES::VAR)
    {
        switch (e.vartype)
        {
        case STD_TYPES::INTEGER:
            e.address = this->address_pointer;
            this->address_pointer += 4;
            break;
        case STD_TYPES::REAL:
            e.address = this->address_pointer;
            this->address_pointer += 8;
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
    for (size_t i = 0; i < this->table.size(); i++)
    {
        auto a = this->table[i];
        if (a.name_or_value == id)
        {
            return a;
        }
    }
    raise(SIGINT);
}

Entry Memory::operator[](int index)
{
    return this->table[index];
}