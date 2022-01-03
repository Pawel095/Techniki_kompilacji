%option noyywrap
%{
    #include "global.hpp"
%}

%%

"program" {return program_t;}

. {return ident_t;}

%%