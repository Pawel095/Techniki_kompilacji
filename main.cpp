#include "global.hpp"

int main(int argc, char const *argv[])
{
    std::atexit(cleanup);
    
    yydebug = 0;

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
        fclose(yyin);
        exit(1);
    }
    init();
    yyparse();
    std::cout << memory.dump().to_string() << std::endl;
    return 0;
}
