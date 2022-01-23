#ifndef ASMFOR_H
#define ASMFOR_H

#include <string>

#include "../program/Entry.hpp"
#include "../global.hpp"

std::string asmfor_op1arg_v(std::string op, std::vector<int> ids);

std::string asmfor_op2args(std::string op, Entry src, Entry dest);
std::string asmfor_op3args(std::string op, Entry e1, Entry e2, Entry e3);

std::string asmfor_relop(std::string op, Entry left, Entry right, Entry result);

#endif