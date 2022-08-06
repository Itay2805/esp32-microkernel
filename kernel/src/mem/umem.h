#pragma once

#include "mem.h"

#define CODE_PAGE_INDEX(x) \
    (((x) - USER_CODE_BASE) / USER_PAGE_SIZE)

#define DATA_PAGE_INDEX(x) \
    (((x) - USER_DATA_BASE) / USER_PAGE_SIZE)

#define CODE_PAGE_ADDR(x) \
    (((x) * USER_PAGE_SIZE) + USER_CODE_BASE)

#define DATA_PAGE_ADDR(x) \
    (((x) * USER_PAGE_SIZE) + USER_DATA_BASE)

#define INVALID_PAGE -1

int umem_alloc_code_page();

int umem_alloc_data_page();

void umem_free_code_page(int ptr);

void umem_free_data_page(int ptr);
