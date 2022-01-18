#ifndef ENTRY_H
#define ENTRY_H

#include <string>
#include "enums.hpp"

class Entry
{
private:
public:
    ENTRY_TYPES type;
    std::string name_or_value;
    int address = -1;
    int mem_index = -1;
    STD_TYPES vartype = UNDEFINED;
    std::string get_asm_var();
};
#endif
