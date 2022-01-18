#include "Entry.hpp"

std::string Entry::get_asm_var()
{
    if (this->type == ENTRY_TYPES::VAR)
        return std::string(std::to_string(this->address));
    else if (this->type == ENTRY_TYPES::CONST)
        return std::string("#") + this->name_or_value;
    return std::string("");
}
