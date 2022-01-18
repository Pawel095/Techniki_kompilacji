#ifndef ASMFOR_H
#define ASMFOR_H

#include <string>

#include "../program/Entry.hpp"
#include "../global.hpp"

std::string asmfor_write(std::vector<std::string *> ids);
std::string asmfor_op2args(std::string op, Entry *src, Entry *dest);
std::string asmfor_op3args(std::string op, Entry *e1, Entry *e2, Entry *e3);

#endif