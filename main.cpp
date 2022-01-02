#include "global.hpp"
#include <iostream>
#include "parser.hpp"

int main(int argc, char const *argv[])
{
    yyparse();
    return 0;
}

int yyerror(const char *a)
{
    std::cout << a;
    return 1;
}