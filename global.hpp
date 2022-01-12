#define BREAKPOINT raise(SIGINT);

#include <iostream>
#include <fstream>
#include <csignal>
#include <string>
#include <vector>

#include "program/enums.hpp"
#include "program/Memory.hpp"

#include "lexer.hpp"
#include "parser.hpp"


using namespace std;

extern ofstream outfile;
extern Memory memory;

int yyparse();
int yyerror(const char *a);

void init();
void cleanup();
bool isInteger(const string *a);