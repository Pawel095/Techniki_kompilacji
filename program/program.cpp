#include "program.hpp"

Program::Program()
{
}

Program::~Program()
{
}
void Program::c_str()
{
    cout << "Program:" << endl;
    cout << "name: " << this->name << endl;
    cout << "io_parameters: ";
    for (auto io_param : this->io_params)
    {
        cout << io_param->c_str() << ", ";
    }
    cout << endl;
}
