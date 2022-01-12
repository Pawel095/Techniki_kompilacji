#include "enums.hpp"

std::string enum2str(ENTRY_TYPES e)
{
    switch (e)
    {
    case ENTRY_TYPES::VAR:
        return std::string("VAR");
    case ENTRY_TYPES::CONST:
        return std::string("CONST");
    case ENTRY_TYPES::PROCEDURE:
        return std::string("PROCEDURE");
    case ENTRY_TYPES::FUNC:
        return std::string("FUNC");

    default:
        return std::string("UNKNOWN");
    }
}
std::string enum2str(STD_TYPES e)
{
    switch (e)
    {
    case STD_TYPES::INTEGER:
        return std::string("INTEGER");
    case STD_TYPES::REAL:
        return std::string("REAL");
    case STD_TYPES::UNDEFINED:
        return std::string("UNDEFINED");

    default:
        return std::string("UNKNOWN");
    }
}