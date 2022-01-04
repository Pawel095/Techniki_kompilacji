%{
    #define YYERROR_VERBOSE 1
%}

%code requires{
    #include "global.hpp"
}


%union{
    string* str;
    vector<string*>* str_v;
}


%token program_t
%token var_t
%token integer_t
%token real_t
%token write_t
%token begin_t
%token end_t
%token <str> ident_t

%type <str_v> identifier_list
%type <str> ident

%%

program: 
    program_t ident '(' identifier_list ')' ';' 
    {program_name = $2;}
    {io_var = $4;}
;

identifier_list: 
    ident {$$=new vector<string*>();$$->push_back($1);}
    | identifier_list ',' ident { $$->push_back($3); }
    
;
ident: ident_t {$$ = yylval.str;}
;

%%
