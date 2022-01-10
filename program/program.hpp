#ifndef PROGRAM_HPP
#define PROGRAM_HPP

#include <iostream>
#include <string>
#include <vector>
#include "Expression.hpp"
#include "Symbol.hpp"

using namespace std;

class Program
{
private:
public:
    // BEGIN: IGNORE IN COMPILER
    string name;
    vector<string *> io_params;
    // END: IGNORE IN COMPILER

    vector<Symbol *> global_vars;
    // TODO: add later
    // procedures
    // functions
    vector<Expression *> main;
    Program();
    ~Program();
    void print();
};
#endif