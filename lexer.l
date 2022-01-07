%option noyywrap
%option yylineno

DIGITS [[:digit:]][[:digit:]]*
NUM {DIGITS}(\.{DIGITS})?(E[+-]?{DIGITS})?

%{
    #include "global.hpp"
    #include "debug/printer.hpp"
%}

%%

[[:blank:]]+ {
    // print_if_debug(yytext,"blank");
}
\n {
    // print_if_debug(yytext,"newline");
}
"program" {
    print_if_debug(yytext,"program_t");
    return program_t;
}
"var" {
    print_if_debug(yytext,"var_t");
    return var_t;
}
"integer" {
    print_if_debug(yytext,"integer_t");
    return integer_t;
}
"real" {
    print_if_debug(yytext,"real_t");
    return real_t;
}
"procedure" {
    print_if_debug(yytext,"procedure_t");
    return procedure_t;
}
"function" {
    print_if_debug(yytext,"function_t");
    return function_t;
}
"begin" {
    print_if_debug(yytext,"begin_t");
    return begin_t;
}
"end" {
    print_if_debug(yytext,"end_t");
    return end_t;
}
"of" {
    print_if_debug(yytext,"of_t");
    return of_t;
}
"if" {
    print_if_debug(yytext,"if_t");
    return if_t;
}
"then" {
    print_if_debug(yytext,"then_t");
    return then_t;
}
"else" {
    print_if_debug(yytext,"else_t");
    return else_t;
}


":=" {
    print_if_debug(yytext,"assign_op_t");
    return assign_op_t;
}



"=" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::EQUAL);
    return relop_t;
}
"<>" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::NOTEQUAL);
    return relop_t;
}
"<" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::LESS);
    return relop_t;
}
"<=" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::LESSEQ);
    return relop_t;
}
">" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::MORE);
    return relop_t;
}
">=" {
    print_if_debug(yytext,"relop_t");
    yylval.cmp = new Comparison(RELOP::MOREEQ);
    return relop_t;
}

"+" {
    print_if_debug(yytext,"sign_t");
    yylval.sign = SIGN::PLUS;
    return sign_t;
}
"-" {
    print_if_debug(yytext,"sign_t");
    yylval.sign = SIGN::MINUS;
    return sign_t;
}

"*" {
    print_if_debug(yytext,"mulop_t");
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"/" {
    print_if_debug(yytext,"mulop_t");
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"div" {
    print_if_debug(yytext,"mulop_t");
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"mod" {
    print_if_debug(yytext,"mulop_t");
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"and" {
    print_if_debug(yytext,"mulop_t");
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"or" {
    print_if_debug(yytext,"or_t");
    // TODO: nie ma zwracanego tekstu
    return or_t;
}

{NUM} {
    print_if_debug(yytext,"num_t");
    yylval.str = new string(yytext);
    return num_t;
}

[[:alpha:]][[:alnum:]]* {
    print_if_debug(yytext,"ident_t");
    yylval.str = new string(yytext);
    return ident_t;
}
. {
    print_if_debug(yytext,"dot");
    return *yytext;
}


%%