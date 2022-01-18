#include <string>

#ifndef ENUMS_H
#define ENUMS_H

enum RELOP
{
    EQUAL,
    NOTEQUAL,
    LESS,
    LESSEQ,
    MORE,
    MOREEQ
};
enum MULOP
{
    STAR,
    SLASH,
    DIV,
    MOD,
    AND
};
enum SIGN
{
    PLUS,
    MINUS
};
enum STD_TYPES
{
    INTEGER,
    REAL,
    UNDEFINED
};
enum SCOPE
{
    GLOBAL,
    LOCAL
};
enum ENTRY_TYPES
{
    VAR,
    CONST,
    FUNC,
    PROCEDURE,
    IGNORE
};
std::string enum2str(ENTRY_TYPES e);
std::string enum2str(STD_TYPES e);
std::string enum2str(MULOP e);
std::string enum2str(SIGN e);
#endif // ENUMS_H