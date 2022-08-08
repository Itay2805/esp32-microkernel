#include "mem.h"

#include <umm_malloc.h>

#include <util/string.h>
#include <util/trace.h>

#include <stdint.h>

extern void* _heap_start;
extern void* _heap_size;

void* UMM_MALLOC_CFG_HEAP_ADDR = NULL;
uint32_t UMM_MALLOC_CFG_HEAP_SIZE = 0;

err_t init_mem() {
    err_t err = NO_ERROR;

    void* heap_start = &_heap_start;
    uint32_t heap_size = (uint32_t)&_heap_size;

    // align the heap start
    void* tmp_start = ALIGN_UP(heap_start, 4);
    uint32_t added = tmp_start - heap_start;
    heap_start = tmp_start;
    heap_size -= added;

    // align the size of the heap properly
    heap_size = ALIGN_DOWN(heap_size, 4);

    UMM_MALLOC_CFG_HEAP_ADDR = heap_start;
    UMM_MALLOC_CFG_HEAP_SIZE = heap_size;
    TRACE("Kernel heap: %p (%S)", UMM_MALLOC_CFG_HEAP_ADDR, UMM_MALLOC_CFG_HEAP_SIZE);

    // initialize it
    umm_init();

cleanup:
    return err;
}

void* malloc(size_t size) {
    return umm_malloc(size);
}

void free(void* ptr) {
    umm_free(ptr);
}
