#pragma once

#include <stdint.h>
#include "util/except.h"

typedef struct vdso_header {
    uint32_t magic;
    uint32_t code_size;
    uint32_t vecbase;
} vdso_header_t;

extern vdso_header_t g_vdso_header;
