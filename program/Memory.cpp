#include "../global.hpp"
#include "Memory.hpp"

Memory::Memory() {}

Memory::~Memory()
{
}

void Memory::set_scope(SCOPE scope)
{
    this->scope = scope;
}
fort::char_table Memory::dump()
{
    cout << "MEMORY: " << endl;
    fort::char_table out;
    out << fort::header << "ENTRY_TYPE"
        << "name_or_value"
        << "address"
        << "STD_TYPE" << fort::endr;
    for (auto e : this->table)
    {
        out << enum2str(e->type) << e->name_or_value << e->address << enum2str(e->vartype) << fort::endr;
    }
    return out;
}
int Memory::add_entry(Entry *e)
{
    size_t index = this->table.size();
    this->table.push_back(e);
    return index;
}
// ONLY FOR VARTYPE AND CONST
void Memory::allocate(int id)
{
    auto e = this->table[id];
    if (e->type == ENTRY_TYPES::VAR)
    {
        switch (e->vartype)
        {
        case STD_TYPES::INTEGER:
            e->address = this->address_pointer;
            this->address_pointer += 4;
            break;
        case STD_TYPES::REAL:
            e->address = this->address_pointer;
            this->address_pointer += 8;
            break;
        }
    }
    else if (e->type == ENTRY_TYPES::CONST)
    {
        if (isInteger(&e->name_or_value))
        {
            e->address = this->address_pointer;
            this->address_pointer += 4;
            e->vartype = STD_TYPES::INTEGER;
        }
        else
        {
            e->address = this->address_pointer;
            this->address_pointer += 8;
            e->vartype = STD_TYPES::REAL;
        }
    }
    else
    {
        // Capture all not variables and skip if not debugging.
        BREAKPOINT;
        return;
    }
}
Entry *Memory::get(string id)
{
    for (auto a : this->table)
    {
        if (a->name_or_value == id)
        {
            return a;
        }
    }
    return nullptr;
}