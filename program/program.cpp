#include "program.hpp"

Program::Program()
{
}

Program::~Program()
{
}
void Program::print()
{
    cout << "Program:" << endl;
    cout << "name: " << this->name << endl;
    cout << "io_parameters: ";
    for (auto io_param : this->io_params)
    {
        cout << io_param->c_str() << ", ";
    }
    cout << endl;

    cout << "global_vars: ";
    for (auto g_var : this->global_vars)
    {
        g_var->print();
    }
    cout << endl;
}
