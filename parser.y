%{
    #include "global.h"
%}

%token NUM
%token DIV
%token MOD
%token ID

%%

parse: expr ';' parse | %empty;

expr: 
    expr '+' term { emit('+', NONE); }|
    expr '-' term { emit('-', NONE); }|
    term;

term : 
    term '*' factor { emit('*', NONE); }|
    term '/' factor { emit('/', NONE); }|
    term DIV factor { emit(DIV, NONE); }|
    term MOD factor { emit(MOD, NONE); }|
    factor;

factor : 
    '(' expr ')'|
    ID { emit(ID, $1); }|
    NUM { emit(NUM, $1); };

%%

void parse(){
    yyparse();
}
void yyerror(char *msg){
    error(msg);
}