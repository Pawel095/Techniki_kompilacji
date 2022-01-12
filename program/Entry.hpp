#ifndef ENTRY_H
#define ENTRY_H

#include <string>
#include "enums.hpp"

using namespace std;

class Entry
{
private:
public:
    ENTRY_TYPES type;
    string name_or_value;
    int address = -1;
    STD_TYPES vartype = UNDEFINED;

    Entry();
    ~Entry();
};
#endif
