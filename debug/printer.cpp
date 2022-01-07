#include "printer.hpp"
#include "../global.hpp"
void print_if_debug(char *c, const char *prefix)
{
#ifdef DEBUG
    cout << prefix << ": \'" << c << "\' ";
#endif
}