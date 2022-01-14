
#include <vector>
#include <string>
#include <iostream>

#include "enums.hpp"
#include "Entry.hpp"
#include "../libfort/lib/fort.hpp"

#ifndef MEMORY_H
#define MEMORY_H

class Memory
{
private:
    std::vector<Entry *> table;
    SCOPE scope;
    int address_pointer = 0;
    unsigned int temp_var_count = 0;

public:
    Memory();
    ~Memory();
    // TODO: implement
    void set_scope(SCOPE scope);

    int add_entry(Entry *e);
    Entry *add_temp_var(STD_TYPES type);
    void allocate(int id);

    Entry *get(string id);
    Entry* operator[](int index);

    fort::char_table dump();
};
#endif