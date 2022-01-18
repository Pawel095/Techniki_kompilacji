#include "global.hpp"

std::ofstream outfile;
Memory memory = Memory();

int yyerror(const char *a)
{
    std::cout << std::endl
              << "In line " << yylineno << ": " << a << std::endl;
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

bool isInteger(const std::string *a)
{
    std::string::size_type dst, ist;
    std::stod(*a, &dst);
    std::stoi(*a, &ist);
    return dst == ist;
}