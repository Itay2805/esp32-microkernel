#pragma once

#include <stdint.h>

#define APP_HEADER_MAGIC 0x20505041

typedef struct app_header {
    uint32_t magic;
    uint32_t code_size;
    uint32_t data_size;
    uint32_t bss_size;
    uint32_t entry;
} app_header_t;
