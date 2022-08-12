#pragma once

#include <util/except.h>
#include <util/defs.h>

#include <stddef.h>

#define USER_CODE_BASE      ((void*)0x40080000)
#define USER_DATA_BASE      ((void*)0x3FFC0000)

#define USER_PAGE_SIZE           SIZE_8KB

// last page of code space, identity mapped
#define VDSO_PAGE_INDEX         15

// last page of data space
#define UCTX_PAGE_INDEX         15

err_t init_mem();

void* malloc(size_t size);

void free(void* ptr);

#define SAFE_FREE(ptr) \
    do { \
        if (ptr != NULL) { \
            free(ptr); \
            ptr = NULL; \
        } \
    } while (0)
