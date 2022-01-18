#define BREAKPOINT raise(SIGINT);

#include <iostream>
#include <fstream>
#include <csignal>
#include <string>
#include <vector>
#include <memory>

#include "program/enums.hpp"
#include "program/Memory.hpp"

#include "lexer.hpp"
#include "parser.hpp"


extern std::ofstream outfile;
extern Memory memory;

int yyparse();
int yyerror(const char *a);

void init();
void cleanup();
bool isInteger(std::string a);