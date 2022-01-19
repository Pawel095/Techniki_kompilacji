#include "Entry.hpp"

std::string Entry::get_asm_var()
{
    if (this->type == ENTRY_TYPES::VAR)
        return std::string(std::to_string(this->address));
    else if (this->type == ENTRY_TYPES::CONST)
        return std::string("#") + this->name_or_value;
    else if (this->type == ENTRY_TYPES::LOCAL_VAR)
    {
        return std::string("BP") + std::to_string(this->address);
    }
    else if (this->type == ENTRY_TYPES::ARGUMENT)
    {
        return std::string("*BP+") + std::to_string(this->address);
    }
    return std::string("");
}
