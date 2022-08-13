#pragma once

#include <stdint.h>
#include <stddef.h>

/**
 * The initrd header
 */
typedef struct initrd_header {
    size_t total_size;
    uint8_t count;
} initrd_header_t;

/**
 * The entry header
 */
typedef struct initrd_entry {
    size_t size;
    char name[64];
} initrd_entry_t;

#define INITRD_NEXT_ENTRY(entry) \
    ((initrd_entry_t*)((uintptr_t) (entry) + sizeof(initrd_entry_t) + (entry)->size))
