enum MULOP
{
    STAR,
    SLASH,
    DIV,
    MOD,
    AND
};
class Multiplication
{
private:
public:
    MULOP type;
    Multiplication(MULOP type);
    ~Multiplication();
};
