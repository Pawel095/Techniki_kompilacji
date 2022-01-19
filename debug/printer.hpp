#include <vector>
#include <string>

void print_if_debug(const char *c, const char *prefix, bool enabled);
void print_if_debug(std::string c, const char *prefix, bool enabled);
void print_if_debug(const std::vector<char *> *strings, const char *prefix, bool enabled);
void print_if_debug(const std::vector<int> ids, const char *prefix, bool enabled);