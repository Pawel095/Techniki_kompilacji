#include "global.hpp"

vector<string *> *io_var = new vector<string *>();
string *program_name = new string();
vector<Variable *> *global_vars = new vector<Variable *>();

int yyerror(const char *a)
{
    std::cout << endl
              << "In line " << yylineno << ": " << a << endl;
    exit(1);
}