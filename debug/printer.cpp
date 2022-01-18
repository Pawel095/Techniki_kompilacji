#include "printer.hpp"
#include "../global.hpp"

void print_if_debug(const char *c, const char *prefix, bool enabled)
{
    if (enabled)
        std::cout << prefix << ": \'" << c << "\' " << std::endl;
}
void print_if_debug(std::string c, const char *prefix, bool enabled)
{
    if (enabled)
    {
        std::cout << prefix << ": \'" << c.c_str() << "\' " << std::endl;
    }
}

void print_if_debug(const std::vector<std::string *> *strings, const char *prefix, bool enabled)
{
    if (enabled)
    {
        for (auto str : *strings)
        {
            std::cout << prefix << ": \'" << str->c_str() << "\'" << std::endl;
        }
    }
}