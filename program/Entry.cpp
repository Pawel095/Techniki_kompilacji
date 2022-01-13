#include "Entry.hpp"

string Entry::get_asm_var()
{
    if (this->type == ENTRY_TYPES::VAR)
        return string(to_string(this->address));
    else if (this->type == ENTRY_TYPES::CONST)
        return string("#") + this->name_or_value;
    return string("");
}