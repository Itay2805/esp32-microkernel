#include "umem.h"
#include "mem.h"

#include <stdint.h>
#include <stddef.h>

/**
 * Code pages that are free to use, we
 * start with all of them except the
 * last one which is used for vdso
 */
static uint16_t m_code_pages = 0x7fff;

/**
 * Data pages that are free to use, we
 * start with all of them
 */
static uint16_t m_data_pages = 0xFFFF;

void* umem_alloc_code_page() {
    // nothing to allocate
    if (m_code_pages == 0) {
        return NULL;
    }

    // find a free page
    int index = __builtin_ffs(m_code_pages);
    m_code_pages &= ~(1 << index);

    // return it as a pointer
    return USER_CODE_BASE + (index * USER_PAGE_SIZE);
}

void* umem_alloc_data_page() {
    // nothing to allocate
    if (m_data_pages == 0) {
        return NULL;
    }

    // find a free page
    int index = __builtin_ffs(m_data_pages);
    m_data_pages &= ~(1 << index);

    // return it as a pointer
    return USER_DATA_BASE + (index * USER_PAGE_SIZE);
}

void umem_free_code_page(void* ptr) {
    // TODO: verify the pointers
    int index = (ptr - USER_CODE_BASE) / USER_PAGE_SIZE;
    m_code_pages |= 1 << index;
}

void umem_free_data_page(void* ptr) {
    int index = (ptr - USER_DATA_BASE) / USER_PAGE_SIZE;
    m_data_pages |= 1 << index;
}
