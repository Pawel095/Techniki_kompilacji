%option noyywrap
%option yylineno

DIGITS [[:digit:]][[:digit:]]*
NUM {DIGITS}(\.{DIGITS})?(E[+-]?{DIGITS})?

%{
    #include "global.hpp"
    #include "debug/printer.hpp"
    bool ENABLEDL=false;
%}

%%

\{[^\{]*?\} {
    // comment. ignore
}

[[:blank:]]+ {
    // print_if_debug(yytext,"blank",ENABLEDL);
}
\n {
    // print_if_debug(yytext,"newline",ENABLEDL);
}
"program" {
    print_if_debug(yytext,"program_t",ENABLEDL);
    return program_t;
}
"var" {
    print_if_debug(yytext,"var_t",ENABLEDL);
    return var_t;
}
"integer" {
    print_if_debug(yytext,"integer_t",ENABLEDL);
    return integer_t;
}
"real" {
    print_if_debug(yytext,"real_t",ENABLEDL);
    return real_t;
}
"procedure" {
    print_if_debug(yytext,"procedure_t",ENABLEDL);
    return procedure_t;
}
"function" {
    print_if_debug(yytext,"function_t",ENABLEDL);
    return function_t;
}
"begin" {
    print_if_debug(yytext,"begin_t",ENABLEDL);
    return begin_t;
}
"end" {
    print_if_debug(yytext,"end_t",ENABLEDL);
    return end_t;
}
"of" {
    print_if_debug(yytext,"of_t",ENABLEDL);
    return of_t;
}
"array" {
    print_if_debug(yytext,"array_t",ENABLEDL);
    return array_t;
}
".." {
    print_if_debug(yytext,"array_t",ENABLEDL);
    return array_range_t;
}



"if" {
    print_if_debug(yytext,"if_t",ENABLEDL);
    return if_t;
}
"then" {
    print_if_debug(yytext,"then_t",ENABLEDL);
    return then_t;
}
"else" {
    print_if_debug(yytext,"else_t",ENABLEDL);
    return else_t;
}
"not" {
    print_if_debug(yytext,"not_t",ENABLEDL);
    return not_t;
}



"while" {
    print_if_debug(yytext,"while_t",ENABLEDL);
    return while_t;
}

"do" {
    print_if_debug(yytext,"do_t",ENABLEDL);
    return do_t;
}

":=" {
    print_if_debug(yytext,"assign_op_t",ENABLEDL);
    return assign_op_t;
}



"=" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp =RELOP::EQUAL;
    return relop_t;
}
"<>" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp = RELOP::NOTEQUAL;
    return relop_t;
}
"<" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp = RELOP::LESS;
    return relop_t;
}
"<=" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp = RELOP::LESSEQ;
    return relop_t;
}
">" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp =RELOP::MORE;
    return relop_t;
}
">=" {
    print_if_debug(yytext,"relop_t",ENABLEDL);
    yylval.cmp = RELOP::MOREEQ;
    return relop_t;
}

"+" {
    print_if_debug(yytext,"sign_t",ENABLEDL);
    yylval.sign = SIGN::PLUS;
    return sign_t;
}
"-" {
    print_if_debug(yytext,"sign_t",ENABLEDL);
    yylval.sign = SIGN::MINUS;
    return sign_t;
}

"*" {
    print_if_debug(yytext,"mulop_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"/" {
    print_if_debug(yytext,"mulop_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"div" {
    print_if_debug(yytext,"mulop_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"mod" {
    print_if_debug(yytext,"mulop_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"and" {
    print_if_debug(yytext,"mulop_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return mulop_t;
}
"or" {
    print_if_debug(yytext,"or_t",ENABLEDL);
    // TODO: nie ma zwracanego tekstu
    return or_t;
}

"write" {
    print_if_debug(yytext,"write_t",ENABLEDL);
    return write_t;
}


{NUM} {
    print_if_debug(yytext,"num_t",ENABLEDL);
    yylval.str = new string(yytext);
    return num_t;
}

[[:alpha:]][[:alnum:]]* {
    print_if_debug(yytext,"ident_t",ENABLEDL);
    yylval.str = new string(yytext);
    return ident_t;
}
. {
    print_if_debug(yytext,"dot",ENABLEDL);
    return *yytext;
}


%%