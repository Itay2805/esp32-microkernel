#include "mem.h"

#include "tlsf.h"

#include <util/string.h>
#include <util/trace.h>

#include <stdint.h>

extern void* _heap_start;
extern void* _heap_size;

static tlsf_t m_tlsf = NULL;

err_t init_mem() {
    err_t err = NO_ERROR;

    // get the size and base
    size_t size = (size_t)&_heap_size;
    uintptr_t base = (uintptr_t)&_heap_start;

    // make sure we have enough space
    CHECK(size >= tlsf_size());

    // allocate area for the tlsf block
    void* mem = (void*)base + tlsf_size();
    base += tlsf_size();
    size -= tlsf_size();

    // init the tlsf block
    m_tlsf = tlsf_create(mem);
    CHECK(m_tlsf != NULL);

    TRACE("Kernel heap: %p (%S)", base, size);

    // add the memory to the tlsf allocator
    CHECK(tlsf_add_pool(m_tlsf, (void*)base, size) != NULL);

cleanup:
    return err;
}

void* malloc(size_t size) {
    return tlsf_malloc(m_tlsf, size);
}

void free(void* ptr) {
    tlsf_free(m_tlsf, ptr);
}
