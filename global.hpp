#include <iostream>
#include <string>
#include <vector>

#include "lexer.hpp"
#include "parser.hpp"
#include "program/program.hpp"

using namespace std;

int yyparse();
int yyerror(const char *a);

extern Program *program;