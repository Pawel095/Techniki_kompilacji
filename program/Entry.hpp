#ifndef ENTRY_H
#define ENTRY_H

#include <string>
#include <vector>
#include "enums.hpp"

class Entry
{
private:
public:
    ENTRY_TYPES type = ENTRY_TYPES::IGNORE;
    std::string name_or_value;
    int address = -1;
    int mem_index = -1;
    STD_TYPES vartype = STD_TYPES::UNDEFINED;
    std::vector<STD_TYPES> arg_types;
    std::string get_asm_var();
    std::string get_asm_ptr();
};
#endif
