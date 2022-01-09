#include "global.hpp"

Program *program = new Program();

int yyerror(const char *a)
{
    std::cout << endl
              << "In line " << yylineno << ": " << a << endl;
    exit(1);
}