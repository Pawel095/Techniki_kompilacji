#define DEBUG

#include <iostream>
#include <string>
#include <vector>

#include "lexer.hpp"
#include "parser.hpp"

using namespace std;

int yyparse();
int yyerror(const char *a);

extern vector<string *> *io_var;
extern string *program_name;
extern vector<Variable *> *global_vars;
