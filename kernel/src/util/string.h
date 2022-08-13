#pragma once

#include <stddef.h>

void* xthal_memcpy(void *dst, const void *src, size_t len);

#define memcpy __builtin_memcpy
#define memset __builtin_memset
