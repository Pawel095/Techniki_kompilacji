%option noyywrap

DIGITS [[:digit:]][[:digit:]]*
NUM {DIGITS}(\.{DIGITS})?(E[+-]?{DIGITS})?

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

":=" {return assign_op_t;}

"=" {yylval.cmp = new Comparison(RELOP::EQUAL); return relop_t;}
"<>" {yylval.cmp = new Comparison(RELOP::NOTEQUAL); return relop_t;}
"<" {yylval.cmp = new Comparison(RELOP::LESS); return relop_t;}
"<=" {yylval.cmp = new Comparison(RELOP::LESSEQ); return relop_t;}
">" {yylval.cmp = new Comparison(RELOP::MORE); return relop_t;}
">=" {yylval.cmp = new Comparison(RELOP::MOREEQ); return relop_t;}


{NUM} {yylval.str = new string(yytext); return num_t;}

[[:alpha:]][[:alnum:]]* { yylval.str = new string(yytext); return ident_t;}
. {return *yytext; }


%%