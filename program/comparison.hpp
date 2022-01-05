#ifndef COMPARISON_H_INCLUDED
#define COMPARISON_H_INCLUDED

enum RELOP{
    EQUAL,
    NOTEQUAL,
    LESS,
    LESSEQ,
    MORE,
    MOREEQ
};
class Comparison
{
private:
public:
    RELOP relop;
    Comparison(RELOP relop);
    ~Comparison();
};

#endif