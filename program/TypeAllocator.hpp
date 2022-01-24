#ifndef TYPE_ALLOCATOR_H
#define TYPE_ALLOCATOR_H

#include "enums.hpp"

struct TypeAllocator
{
    STD_TYPES type;
    bool is_array;
    int arr_size;
    int arr_start;
};

#endif