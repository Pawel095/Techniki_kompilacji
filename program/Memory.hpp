
#include <vector>
#include <string>
#include <iostream>
#include <sstream>

#include "enums.hpp"
#include "Entry.hpp"
#include "../libfort/lib/fort.hpp"

#ifndef MEMORY_H
#define MEMORY_H

class Memory
{
private:
    std::vector<Entry> table;
    int address_pointer = 0;
    unsigned int temp_var_count = 0;
    std::stringstream func_buffer;

    int label_count = 0;

    SCOPE scope;
    int bp_up = 0;
    int bp_dn = 0;

public:
    Entry current_function;
    std::vector<Entry> label_stack = std::vector<Entry>();

    Memory();
    ~Memory();
    void set_scope(SCOPE scope);
    SCOPE get_scope();
    void reset_scope();
    std::string func_body();
    int local_temp_bytes();

    void initial_bp(bool has_return_var);

    int add_entry(Entry e);
    Entry add_temp_var(STD_TYPES type);
    void allocate(int id);

    Entry get(std::string id);
    bool exists(std::string id);

    void update_entry(int index, Entry e);

    fort::char_table dump();

    Entry operator[](int index);
    void operator<<(std::string);

    Entry make_label();
};
#endif
