#include "global.hpp"

int main(int argc, char const *argv[])
{
    const char *cwd = argv[0];
    const char *infile = argv[1];
    if (argc != 2)
    {
        std::cout << "Usage: ./out FILEPATH";
    }
    yyin = fopen(argv[1], "r");
    if (yyin == nullptr)
    {
        std::cout << "Wrong path: " << argv[1] << std::endl;
    }
    yyparse();
    return 0;
}

int yyerror(const char *a)
{
    std::cout<<endl << "In line " << yylineno << ": " << a << endl;
    return 1;
}