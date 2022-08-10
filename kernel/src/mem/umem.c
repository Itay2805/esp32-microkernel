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

int umem_alloc_code_page() {
    // nothing to allocate
    if (m_code_pages == 0) {
        return INVALID_PAGE;
    }

    // find a free page
    int index = __builtin_ffs(m_code_pages) - 1;
    m_code_pages &= ~(1 << index);

    // return it as a pointer
    return index;
}

int umem_alloc_data_page() {
    // nothing to allocate
    if (m_data_pages == 0) {
        return INVALID_PAGE;
    }

    // find a free page
    int index = __builtin_ffs(m_data_pages) - 1;
    m_data_pages &= ~(1 << index);

    // return it as a pointer
    return index;
}

void umem_free_code_page(int index) {
    // TODO: verify the pointers
    m_code_pages |= 1 << index;
}

void umem_free_data_page(int index) {
    m_data_pages |= 1 << index;
}
