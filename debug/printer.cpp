#include "printer.hpp"
#include "../global.hpp"

void print_if_debug(const char *c, const char *prefix, bool enabled)
{
    if (enabled)
        cout << prefix << ": \'" << c << "\' " << endl;
}
void print_if_debug(const string c, const char *prefix, bool enabled)
{
    if (enabled)
    {
        cout << prefix << ": \'" << c.c_str() << "\' " << endl;
    }
}

void print_if_debug(const vector<string *> *strings, const char *prefix, bool enabled)
{
    if (enabled)
    {
        for (auto str : *strings)
        {
            cout << prefix << ": \'" << str->c_str() << "\'" << endl;
        }
    }
}