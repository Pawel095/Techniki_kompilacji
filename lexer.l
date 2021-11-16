%{
    #include "global.h"
    int lineno = 1; // lexer.c:3
    int tokenval = NONE; // lexer.c:4
%}

%%

[a-zA-Z]+  { return; }
\n         { return; }
.          { return; }

%%

int lexan() {
    yylex();
}