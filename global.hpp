#include <iostream>
#include <vector>
#include <string>

#include "lexer.hpp"
#include "parser.hpp"

using namespace std;

int yyparse();
int yyerror(const char* a);