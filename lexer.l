%{
    #include "global.h"
    #include "lexutils/lexutils.h"
    int lineno = 1; // lexer.c:3
    // int yylval = NONE; // lexer.c:4
%}

%%

[[:blank:]]+ {/*lexer.c:11 */}
\n { lineno++; /*lexer.c:13 */}
[[:digit:]]+ {/*lexer.c:15 */ yylval=atoi(yytext); return NUM;}
mod { return MOD; }
div { return DIV; }
[[:alpha:]][[:alnum:]]* { /*lexer.c:21,32:39 */ return handle_alnum(yytext); }
. {/*lexer.c:45 */ /*yylval = NONE;*/ return yytext[0]; }

%%