#pragma once

#define ARRAY_LEN(x) (sizeof(x) / sizeof(x[0]))

#define PACKED __attribute__((packed))
#define STATIC_ASSERT(x) _Static_assert(x, #x)

#define _STR(x) #x
#define STR(x) _STR(x)

typedef char symbol_t[];
