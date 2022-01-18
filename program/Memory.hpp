
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

    std::vector<std::vector<Entry *>> scope_stack;
    int current_scope_index = -1;

    std::vector<Entry *> current_scope();

public:
    Memory();
    ~Memory();
    void set_scope(SCOPE scope);
    void create_local_scope();

    int add_entry(Entry *e);
    Entry *add_temp_var(STD_TYPES type);
    void allocate(int id);

    Entry *get(std::string id);
    Entry *operator[](int index);

    fort::char_table dump();
};
#endif