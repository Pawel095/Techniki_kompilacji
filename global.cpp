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
    std::cout << "Cleaning up." << std::endl;
    if (yyin != nullptr)
        fclose(yyin);
    yylex_destroy();
    outfile.close();
}

bool isInteger(std::string a)
{
    std::string::size_type dst, ist;
    try
    {
            std::stod(a, &dst);
            std::stoi(a, &ist);
    }
    catch(const std::exception& e)
    {
        std::cerr << "the value is too big, assumint it is an integer." << '\n';
        return true;
    }
    return dst == ist;
}