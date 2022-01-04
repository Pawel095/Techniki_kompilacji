enum TYPES
{
    INTEGER,
    REAL,
    ARRAY
};
class Variable
{
private:
public:
    TYPES type;
    const char *__str__();
    Variable(TYPES type);
    ~Variable();
};