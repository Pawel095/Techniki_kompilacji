#include "Symbol.hpp"

Symbol::Symbol(/* args */)
{
}

Symbol::~Symbol()
{
}
void Symbol::print()
{
    string type_str;
    switch (this->type)
    {
    case STD_TYPES::INTEGER:
        type_str = string("integer");
        break;
    case STD_TYPES::REAL:
        type_str = string("real");
        break;
    default:
        type_str = string("UNKNOWN");
    }
    cout << this->name->c_str() << ":"<<type_str;
}