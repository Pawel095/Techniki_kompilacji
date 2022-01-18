#include "asmfor.hpp"

std::string asmfor_op2args(std::string op, Entry e1, Entry e2)
{
    std::string ret = std::string("");
    ret += op + "."; // mov.
    if (e1.vartype == STD_TYPES::INTEGER)
        ret += "i ";
    else if (e1.vartype == STD_TYPES::REAL)
        ret += "r ";
    // ret = 'mov.r '
    ret += e1.get_asm_var() + ", ";
    ret += e2.get_asm_var();
    ret += "\n";
    return ret;
}

std::string asmfor_write(std::vector<char *> ids)
{
    std::string r = std::string("");
    for (auto id : ids)
    {
        Entry e = memory.get(id);
        r += "write.";
        if (e.vartype == STD_TYPES::INTEGER)
            r += "i";
        if (e.vartype == STD_TYPES::REAL)
            r += "r";
        r += " ";
        r += std::to_string(e.address);
        r += "\n";
    }
    return r;
}

// GENCODE!
std::string asmfor_op3args(std::string op, Entry e1, Entry e2, Entry e3)
{
    std::string ret = std::string("");
    ret += op + "."; // mov.
    if (e1.vartype == STD_TYPES::INTEGER)
        ret += "i ";
    else if (e1.vartype == STD_TYPES::REAL)
        ret += "r ";
    // ret = 'mov.r '
    ret += e1.get_asm_var() + ", ";
    ret += e2.get_asm_var() + ", ";
    ret += e3.get_asm_var();
    ret += "\n";
    return ret;
}