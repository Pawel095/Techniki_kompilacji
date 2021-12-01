#include "../global.h"
int handle_alnum(char lexbuf[])
{
    int p = lookup(lexbuf);
    if (p == 0)
        p = insert(lexbuf, ID);
    yylval = p;
    return symtable[p].token;
}