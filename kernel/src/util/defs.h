#pragma once

#define ARRAY_LEN(x) (sizeof(x) / sizeof(x[0]))

#define PACKED __attribute__((packed))
#define STATIC_ASSERT(x) _Static_assert(x, #x)

#define _STR(x) #x
#define STR(x) _STR(x)

#define FOR_EACH_BIT(num, it) \
    if (num != 0) \
        for( \
            int it = __builtin_ffs(num); \
            num; \
            num &= ~it, \
            it = __builtin_ffs(num) \
        )

