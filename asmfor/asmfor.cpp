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
    return instr + e->name_or_value + ", " + std::to_string(e->address) + "\n";
}
std::string asmfor_movassign(Entry *src, Entry *dest)
{
    // TODO: check if types match later
    cout << "\'asmfor_movassign\' WORKS FOR INT ONLY RIGHT NOW!!!" << endl;
    std::string instr;
    instr = string("mov.i ");


    return instr + to_string(src->address) + ", " + std::to_string(dest->address) + "\n";
}
std::string asmfor_add2memaddr(Entry *e1, Entry *e2, Entry *result)
{
    // TODO: check if types match later
    cout << "\'asmfor_add2memaddr\' WORKS FOR INT ONLY RIGHT NOW!!!" << endl;

    return string("add.i ") + to_string(e1->address) + ", " + to_string(e2->address) + "," + to_string(result->address) + "\n";
}
std::string asmfor_write(vector<string *> ids)
{
    string r = string("");
    for (auto id : ids)
    {
        Entry *e = memory.get(*id);
        r += "write.";
        if (e->vartype == STD_TYPES::INTEGER)
            r += "i";
        if (e->vartype == STD_TYPES::REAL)
            r += "r";
        r += " ";
        r += to_string(e->address);
        r += "\n";
    }
    return r;
}