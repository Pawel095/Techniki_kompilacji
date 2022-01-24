#include "Entry.hpp"

std::string Entry::get_asm_var()
{
    switch (this->type)
    {
    case ENTRY_TYPES::VAR:
        return std::string(std::to_string(this->address));
    case ENTRY_TYPES::CONST:
        return std::string("#") + this->name_or_value;
    case ENTRY_TYPES::LOCAL_VAR:
        return std::string("BP") + std::to_string(this->address);
    case ENTRY_TYPES::ARGUMENT:
        return std::string("*BP+") + std::to_string(this->address);
    case ENTRY_TYPES::FUNC:
        return std::string("*BP+") + std::to_string(this->address);
    case ENTRY_TYPES::LABEL:
        return std::string("#") + this->name_or_value;
    case ENTRY_TYPES::ARRAY:
        return "*" + std::to_string(this->address);

    default:
        return std::string("___");
    }
}
std::string Entry::get_asm_ptr()
{
    switch (this->type)
    {
    case ENTRY_TYPES::VAR:
        return std::string("#") + std::to_string(this->address);
    case ENTRY_TYPES::CONST:
        return std::string("Why the fork are you getting a pointer of a const?");
    case ENTRY_TYPES::LOCAL_VAR:
        return std::string("#BP") + std::to_string(this->address);
    case ENTRY_TYPES::ARGUMENT:
        return std::string("BP+") + std::to_string(this->address);
    case ENTRY_TYPES::LABEL:
        return this->name_or_value + std::string(":");

    default:
        return std::string("___");
    }
}