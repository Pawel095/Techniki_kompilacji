#ifndef ASMFOR_H
#define ASMFOR_H

#include <string>

#include "../program/Entry.hpp"
#include "../global.hpp"

std::string asmfor_op2args(string op, Entry *src, Entry *dest);
std::string asmfor_write(vector<string *> ids);
std::string asmfor_op3args(string op, Entry *e1, Entry *e2, Entry *e3);

#endif