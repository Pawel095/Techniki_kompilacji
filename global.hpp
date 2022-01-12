#define BREAKPOINT raise(SIGINT);

#include <iostream>
#include <csignal>
#include <string>
#include <vector>

#include "program/enums.hpp"

#include "lexer.hpp"
#include "parser.hpp"


using namespace std;

int yyparse();
int yyerror(const char *a);