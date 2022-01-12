#ifndef ASMFOR_H
#define ASMFOR_H

#include <string>

#include "../program/Entry.hpp"
#include "../global.hpp"

std::string asmfor_movconst(Entry *e);
std::string asmfor_movassign(Entry *src, Entry *dest);
std::string asmfor_add2memaddr(Entry *e1, Entry *e2, Entry *result);
std::string asmfor_write(vector<string *> ids);

#endif