%{
    #define YYERROR_VERBOSE 1
    bool ENABLEDP=true;
%}

%code requires{
    #include "./debug/printer.hpp"
    #include "global.hpp"
}

%union{
    string* str;
    vector<string*>* str_v;
    RELOP cmp;
    STD_TYPES std_type;
    SIGN sign;
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
%type <std_type> standard_type
%type <std_type> type
%type <str> num


%%

program:
    program_t id '(' identifier_list ')' ';' 
    declarations
    subprogram_declarations
    compound_statement '.'
;
identifier_list:
    id
    | identifier_list ',' id

;
declarations:
    declarations var_t identifier_list ':' type ';'
    | %empty
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
;
num:
    num_t
;
%%
