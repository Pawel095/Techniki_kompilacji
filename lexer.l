%option noyywrap
%{
    #include "global.hpp"
    #include "parser.hpp"
%}

%%

"program" {return program_t;}

. {return ident_t;}

%%