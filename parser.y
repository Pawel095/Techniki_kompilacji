%{
    #define YYERROR_VERBOSE 1
    bool ENABLEDP=true;
%}

%code requires{
    #include "program/variable.hpp"
    #include "program/comparison.hpp"
    #include "program/sign.hpp"
    #include "./debug/printer.hpp"
    #include "program/Symbol.hpp"
    #include "global.hpp"
}

%union{
    string* str;
    vector<string*>* str_v;
    TYPES type;
    Variable *var;
    Comparison *cmp;
    SIGN sign;
    vector<Symbol*>* symbol_v;
}

%token program_t
%token var_t
%token integer_t
%token real_t
%token array_t
%token begin_t
%token end_t
%token of_t
%token function_t
%token procedure_t
%token array_range_t
%token ident_t
%token num_t

%token while_t
%token do_t

%token if_t
%token else_t
%token then_t

%token assign_op_t
%token relop_t
%token sign_t
%token mulop_t
%token or_t
%token not_t

%type <str> id
%type <str_v> identifier_list
%type <symbol_v> declarations

%%

program:
    program_t id '(' identifier_list ')' ';' 
    {
        print_if_debug($2->c_str(),"program[0]->id",ENABLEDP);
        program->name= *$2;
        print_if_debug($4,"program[0]->identifier_list",ENABLEDP);
        program->io_params= *$4;
    }
    declarations
    {
        print_if_debug($8,"program[1]->declarations",ENABLEDP);
    }
    subprogram_declarations
    compound_statement '.'
;
identifier_list:
    id
    {
        print_if_debug($1->c_str(),"identifier_list[0]->id",ENABLEDP);
        $$ = new vector<string*>();
        $$->push_back($1);
    }
    | identifier_list ',' id
    {
        print_if_debug($3->c_str(),"identifier_list[1]->id",ENABLEDP);
        $$->push_back($3);
    }

;
declarations:
    declarations var_t identifier_list ':' type ';'
    {
        $$ = $1;
        print_if_debug($3,"declarations[0]->identifier_list",ENABLEDP);
        for (auto ident:*$3){
            
        }
    }
    | %empty
    {
        print_if_debug("[]","declarations[1]->\%empty",ENABLEDP);
        $$ = new vector<Symbol*>();
    }
;
type:
    standard_type
    | array_t '[' num array_range_t num ']' of_t standard_type
;
standard_type:
    integer_t
    | real_t
;
subprogram_declarations:
    subprogram_declarations subprogram_declaration ';'
    | %empty
;
subprogram_declaration: 
    subprogram_head declarations compound_statement
;
subprogram_head:
    function_t id arguments ':' standard_type ';'

    | procedure_t id arguments ';'
    
;
arguments:
    '(' parameter_list ')'

    | %empty
;
parameter_list:
    identifier_list ':' type

    | parameter_list ';' identifier_list ':' type
;
compound_statement: 
    begin_t
    optional_statements 
    end_t
;
optional_statements: 
    statement_list
    | %empty
;
statement_list:
    statement 
    | statement_list ';' statement
;
statement: 
    variable assign_op_t expression 
    | procedure_statement
    | compound_statement
    | if_t expression then_t statement else_t statement 
    | while_t expression do_t statement
;
variable:
    id 
    | id '[' expression ']'
;
procedure_statement:
    id
    | id '(' expression_list ')'
;
expression_list:
    expression 
    | expression_list ',' expression
;
expression:
    simple_expression 
    | simple_expression relop_t simple_expression 
;
simple_expression:
    term 
    | sign_t term 
    | simple_expression sign_t term 
    | simple_expression or_t term
;
term:
    factor
    | term mulop_t factor 
;
factor: 
    variable
    | id '(' expression_list ')'
    | num
    | '(' expression ')'
    | not_t factor
;
id:
    ident_t 
    {
        print_if_debug($$->c_str(),"id->ident_t",ENABLEDP);
        yylval.str = $$;
    }
;
num:
    num_t 
;
%%
