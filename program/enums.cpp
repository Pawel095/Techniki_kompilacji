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
std::string enum2str(MULOP e)
{
    switch (e)
    {
    case MULOP::STAR:
        return std::string("STAR");
    case MULOP::SLASH:
        return std::string("SLASH");
    case MULOP::DIV:
        return std::string("DIV");
    case MULOP::MOD:
        return std::string("MOD");
    case MULOP::AND:
        return std::string("AND");

    default:
        return std::string("UNKNOWN");
    }
}
std::string enum2str(SIGN e)
{
    switch (e)
    {
    case SIGN::PLUS:
        return std::string("PLUS");
    case SIGN::MINUS:
        return std::string("MINUS");

    default:
        return std::string("UNKNOWN");
    }
}