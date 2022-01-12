#include "global.hpp"

ofstream outfile;
Memory memory = Memory();

int yyerror(const char *a)
{
    std::cout << endl
              << "In line " << yylineno << ": " << a << endl;
    exit(1);
}

void init()
{
    outfile.open("output.asm");
}
void cleanup()
{
    outfile.close();
}

bool isInteger(const string *a)
{
    string::size_type dst, ist;
    std::stod(*a, &dst);
    std::stoi(*a, &ist);
    return dst == ist;
}