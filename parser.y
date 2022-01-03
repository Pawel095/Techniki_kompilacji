%{
    #include "global.hpp"
%}

%token program_t
%token var_t
%token integer_t
%token real_t
%token write_t
%token begin_t
%token end_t
%token ident_t
%token anything_t


%%

program: program_t ident_t '(' identifier_list ')' ';'

identifier_list: ident_t | identifier_list ','

%%
