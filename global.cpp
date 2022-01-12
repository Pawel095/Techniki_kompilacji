#include "global.hpp"

int yyerror(const char *a)
{
    std::cout << endl
              << "In line " << yylineno << ": " << a << endl;
    exit(1);
}