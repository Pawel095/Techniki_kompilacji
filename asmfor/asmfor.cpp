#include "asmfor.hpp"

std::string asmfor_movconst(Entry *e)
{
    std::string instr;
    if (e->vartype == STD_TYPES::INTEGER)
    {
        instr = string("mov.i #");
    }
    else if (e->vartype == STD_TYPES::REAL)
    {
        instr = string("mov.r #");
    }
    return instr + e->name_or_value + ", " + std::to_string(e->address);
}