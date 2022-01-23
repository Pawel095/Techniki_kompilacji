#include "asmfor.hpp"

std::string asmfor_op1arg_v(std::string op, std::vector<int> ids)
{
    std::string r = std::string("");
    for (auto id : ids)
    {
        Entry e = memory[id];
        r += op + ".";
        if (e.vartype == STD_TYPES::INTEGER)
            r += "i";
        if (e.vartype == STD_TYPES::REAL)
            r += "r";
        r += " ";
        r += e.get_asm_var();
        r += "\n";
    }
    return r;
}
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

std::string asmfor_relop(std::string op, Entry left, Entry right, Entry result)
{
    Entry true_ = Entry();
    true_.type = ENTRY_TYPES::CONST;
    true_.name_or_value = std::string("1");
    true_.vartype = STD_TYPES::INTEGER;

    Entry false_ = Entry();
    false_.type = ENTRY_TYPES::CONST;
    false_.name_or_value = std::string("0");
    false_.vartype = STD_TYPES::INTEGER;

    auto true_l = memory.make_label();
    auto end_l = memory.make_label();

    std::string ret = std::string();

    ret += asmfor_op3args(op, left, right, true_l);
    ret += asmfor_op2args(std::string("mov"), false_, result);
    ret += std::string("jump.i ") + end_l.get_asm_var() + "\n";
    ret += true_l.get_asm_ptr() + "\n";
    ret += asmfor_op2args(std::string("mov"), true_, result);
    ret += end_l.get_asm_ptr() + "\n";

    return ret;
}