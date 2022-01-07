%{
    #define YYERROR_VERBOSE 1
%}

%code requires{
    #include "program/variable.hpp"
    #include "program/comparison.hpp"
    #include "program/sign.hpp"
    #include "global.hpp"
}

%union{
    string* str;
    vector<string*>* str_v;
    TYPES type;
    Variable *var;
    Comparison *cmp;
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
%token <str> ident_t
%token <str> num_t

%token while_t
%token do_t

%token if_t
%token else_t
%token then_t

%token assign_op_t
%token relop_t
%token <sign> sign_t
%token mulop_t
%token or_t
%token not_t

%type <str_v> identifier_list
%type <str> id
%type <type> standard_type
%type <var> type
%type <str> num
%type <str> variable

%%

program:
    program_t id '(' identifier_list ')' ';' 
    {
        program_name = $2;
        io_var = $4;
        #ifdef DEBUG
        cout<<"Program name is "<<$2->c_str()<<endl;
        #endif
    }
    declarations
    subprogram_declarations
    compound_statement '.'
;
identifier_list:
    id
    {$$=new vector<string*>();$$->push_back($1);} 
    
    | identifier_list ',' id
    { $$->push_back($3); }

;
declarations:
    declarations var_t identifier_list ':' type ';'
    {
        #ifdef DEBUG
        for(auto var_name : *$3){
            cout<<var_name->c_str()<<":"<<$5->__str__()<<endl;
        }
        #endif
    }
    | %empty
;
type:
    standard_type
    {$$ = new Variable($1);}

    | array_t '[' num array_range_t num ']' of_t standard_type
    { $$ = new Variable(TYPES::ARRAY);}
;
standard_type:
    integer_t 
    {$$ = TYPES::INTEGER;}

    | real_t 
    {$$ = TYPES::REAL;}
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
    {cout<<"Procedure "<<$2->c_str()<<endl;}
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
    id { $$ = $1;}
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
    variable {cout<<"variable: "<<$1->c_str()<<endl;}
    | id '(' expression_list ')'
    | num
    | '(' expression ')'
    | not_t factor
;
id:
    ident_t {$$ = yylval.str;}
;
num:
    num_t { $$ = yylval.str; }
;
%%
