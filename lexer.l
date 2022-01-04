%option noyywrap
%{
    #include "global.hpp"
%}

%%

[[:blank:]]+ {}
\n {}

"program" {return program_t;}
"var" {return var_t;}
"integer" {return integer_t;}
"real" {return real_t;}

[[:alpha:]][[:alnum:]]* { yylval.str = new string(yytext); return ident_t;}
. {return *yytext; }


%%