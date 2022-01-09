#ifndef PROGRAM_HPP
#define PROGRAM_HPP

#include <iostream>
#include <string>
#include <vector>
#include "variable.hpp"
#include "statement.hpp"
#include "Symbol.hpp"

using namespace std;

class Program
{
private:
public:
    string name;
    vector<string *> io_params;
    vector<Symbol *> global_vars;
    // TODO: add later
    // procedures
    // functions
    vector<Statement *> main;
    Program();
    ~Program();
    void c_str();
};
#endif