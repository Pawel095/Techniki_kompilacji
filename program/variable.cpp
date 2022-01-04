#include "variable.hpp"

Variable::Variable(TYPES type)
{
    this->type = type;
}

Variable::~Variable()
{
}
const char *Variable::__str__()
{
    switch (this->type)
    {
    case TYPES::INTEGER:
        return "integer";
    case TYPES::REAL:
        return "real";
    case TYPES::ARRAY:
        return "array";
    default:
        return "UNKNOWN";
    }
}
