enum STATEMENT_TYPE{
    MATHOP
};

class Statement
{
private:
    STATEMENT_TYPE type;

public:
    Statement(STATEMENT_TYPE t);
    ~Statement();
};
