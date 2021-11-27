%{
    #include "global.h"
    #include "lexutils/lexutils.h"
    int lineno = 1; // lexer.c:3
    int tokenval = NONE; // lexer.c:4
%}

%%

[[:blank:]]+ {/*lexer.c:11 */} 
\n { lineno++; /*lexer.c:13 */}
[[:digit:]]+ {/*lexer.c:15 */ tokenval=atoi(yytext); return NUM;}
mod { return MOD; }
div { return DIV; }
[[:alpha:][:digit:]]+ { /*lexer.c:21,32:39 */ return handle_alnum(yytext); }
<<EOF>> {/*lexer.c:41 */return DONE; }
. {/*lexer.c:45 */ tokenval = NONE; return yytext[0]; }

%%

int lexan() {
    return yylex();
}