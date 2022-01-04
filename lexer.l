%option noyywrap
%{
    #include "global.hpp"
%}

%%

[[:blank:]]+ {}
\n {}

"program" {return program_t;}

[[:alpha:]][[:alnum:]]* { yylval.str = new string(yytext); return ident_t;}
. {return *yytext; }


%%