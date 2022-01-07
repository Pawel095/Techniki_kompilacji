%option noyywrap
%option yylineno

DIGITS [[:digit:]][[:digit:]]*
NUM {DIGITS}(\.{DIGITS})?(E[+-]?{DIGITS})?

%{
    #include "global.hpp"
    #include "debug/printer.hpp"
    const char* PRF = "";
%}

%%

[[:blank:]]+ {
    print_if_debug(yytext,PRF);
}
\n {
    cout<<endl;
}
"program" {
    print_if_debug(yytext,PRF);
    return program_t;
}
"var" {
    print_if_debug(yytext,PRF);
    return var_t;
}
"integer" {
    print_if_debug(yytext,PRF);
    return integer_t;
}
"real" {
    print_if_debug(yytext,PRF);
    return real_t;
}
"procedure" {
    print_if_debug(yytext,PRF);
    return procedure_t;
}
"function" {
    print_if_debug(yytext,PRF);
    return function_t;
}
"begin" {
    print_if_debug(yytext,PRF);
    return begin_t;
}
"end" {
    print_if_debug(yytext,PRF);
    return end_t;
}
"of" {
    print_if_debug(yytext,PRF);
    return of_t;
}



":=" {
    print_if_debug(yytext,PRF);
    return assign_op_t;
}



"=" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::EQUAL);
    return relop_t;
}
"<>" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::NOTEQUAL);
    return relop_t;
}
"<" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::LESS);
    return relop_t;
}
"<=" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::LESSEQ);
    return relop_t;
}
">" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::MORE);
    return relop_t;
}
">=" {
    print_if_debug(yytext,PRF);
    yylval.cmp = new Comparison(RELOP::MOREEQ);
    return relop_t;
}
"+" {
    print_if_debug(yytext,PRF);
    yylval.sign = SIGN::PLUS;
    return sign_t;
}
"-" {
    print_if_debug(yytext,PRF);
    yylval.sign = SIGN::MINUS;
    return sign_t;
}


{NUM} {
    print_if_debug(yytext,PRF);
    yylval.str = new string(yytext);
    return num_t;
}

[[:alpha:]][[:alnum:]]* {
    print_if_debug(yytext,PRF);
    yylval.str = new string(yytext);
    return ident_t;
}
. {
    cout<<yytext;
    return *yytext;
}


%%