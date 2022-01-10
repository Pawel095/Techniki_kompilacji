#ifndef SYMBOL_HPP
#define SYMBOL_HPP

#include <string>
#include <iostream>
using namespace std;

enum STD_TYPES
{
    INTEGER,
    REAL,
};
class Symbol
{
private:
public:
    string *name;
    STD_TYPES type;
    Symbol();
    ~Symbol();
    void print();
};

#endif