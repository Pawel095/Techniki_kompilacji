#include <string>

#ifndef ENUMS_H
#define ENUMS_H

enum class RELOP
{
    EQUAL,
    NOTEQUAL,
    LESS,
    LESSEQ,
    MORE,
    MOREEQ
};
enum class MULOP
{
    STAR,
    SLASH,
    DIV,
    MOD,
    AND
};
enum class SIGN
{
    PLUS,
    MINUS
};
enum class STD_TYPES
{
    INTEGER,
    REAL,
    UNDEFINED
};
enum class SCOPE
{
    GLOBAL,
    LOCAL
};
enum class ENTRY_TYPES
{
    VAR,
    LOCAL_VAR,
    ARRAY,
    ARGUMENT,
    CONST,
    FUNC,
    PROCEDURE,
    LABEL,
    IGNORE
};
std::string enum2str(ENTRY_TYPES e);
std::string enum2str(STD_TYPES e);
std::string enum2str(MULOP e);
std::string enum2str(SIGN e);
#endif // ENUMS_H