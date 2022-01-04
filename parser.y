%{
    #define YYERROR_VERBOSE 1
%}

%code requires{
    #include "program/variable.hpp"
    #include "global.hpp"
}


%union{
    string* str;
    vector<string*>* str_v;
    TYPES type;
    Variable *variable;
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
%type <type> standard_type
%type <variable> type

%%

program:
    program_t ident '(' identifier_list ')' ';' 
    {
        program_name = $2;
        io_var = $4;
        #ifdef DEBUG
        cout<<"Program name is "<<$2->c_str()<<endl;
        #endif
    }
    declarations
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
    | %empty // array type goes here
    { $$ = new Variable(TYPES::ARRAY);}
;

identifier_list:
    ident
    {$$=new vector<string*>();$$->push_back($1);} |
    identifier_list ',' ident
    { $$->push_back($3); }
;
ident:
    ident_t {$$ = yylval.str;}
;

standard_type:
    integer_t {$$ = TYPES::INTEGER;}
    | real_t {$$ = TYPES::REAL;}
;
%%
