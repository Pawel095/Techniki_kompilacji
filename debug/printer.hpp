#include <vector>
#include <string>

using namespace std;

void print_if_debug(const char *c, const char *prefix, bool enabled);
void print_if_debug(const string c, const char *prefix, bool enabled);
void print_if_debug(const vector<string *> *strings, const char *prefix, bool enabled);