#include <util/string.h>

#include "loader.h"
#include "task.h"
#include "app.h"
#include "mem/umem.h"
#include "scheduler.h"
#include "drivers/pid.h"

err_t loader_load_app(const char* name, void* app, size_t app_size) {
    err_t err = NO_ERROR;
    int8_t pages[MAX_PAGE_COUNT * 2];
    memset(pages, -1, sizeof(pages));

    // get and validate the header
    app_header_t* header = app;
    CHECK(header->magic == APP_HEADER_MAGIC);
    CHECK(app_size >= sizeof(app_header_t));
    CHECK(app_size >= header->code_size + header->data_size);
    CHECK(USER_CODE_BASE <= header->entry && header->entry < USER_CODE_BASE + header->code_size);

    // create the task
    task_t* task = create_task((void*)header->entry, name);
    CHECK_ERROR(task != NULL, ERROR_OUT_OF_RESOURCES);

    // prepare the sizes for allocation
    size_t code_pages = ALIGN_UP(header->code_size, USER_PAGE_SIZE) / USER_PAGE_SIZE;
    size_t data_pages = ALIGN_UP(header->data_size + header->bss_size, USER_PAGE_SIZE) / USER_PAGE_SIZE;
    CHECK(code_pages < MAX_PAGE_COUNT);
    CHECK(data_pages < MAX_PAGE_COUNT);

    TRACE("Starting app `%s` (%d code pages, %d data pages)",
          name, code_pages, data_pages);

    void* ptr = header + 1;
    size_t code_size_left = header->code_size;
    size_t data_size_left = header->data_size;

    //
    // allocate the pages, both data nad code
    //

    for (int i = 0; i < code_pages; i++) {
        // allocate the page
        int page_idx = umem_alloc_code_page();
        CHECK_ERROR(page_idx != -1, ERROR_OUT_OF_RESOURCES);
        pages[i] = (int8_t)page_idx;

        // copy it
        size_t to_copy = MINU(code_size_left, USER_PAGE_SIZE);
        void* krnl_ptr = (void*)CODE_PAGE_ADDR(page_idx);
        xthal_memcpy(krnl_ptr, ptr, to_copy);
        code_size_left -= to_copy;
        ptr += to_copy;

        // map it nicely
        CHECK_AND_RETHROW(mmu_map(&task->mmu, MMU_SPACE_CODE, i, PAGE_ENTRY(page_idx)));
        TRACE("> %p --> %p", CODE_PAGE_ADDR(i), CODE_PAGE_ADDR(page_idx));
    }

    for (int i = 0; i < data_pages; i++) {
        // allocate the page
        int page_idx = umem_alloc_data_page();
        CHECK_ERROR(page_idx != -1, ERROR_OUT_OF_RESOURCES);
        pages[i + MAX_PAGE_COUNT] = (int8_t)page_idx;

        // copy it
        size_t to_copy = MINU(data_size_left, USER_PAGE_SIZE);
        void* krnl_ptr = (void*)DATA_PAGE_ADDR(page_idx);
        xthal_memcpy(krnl_ptr, ptr, to_copy);
        data_size_left -= to_copy;
        ptr += to_copy;

        // map it nicely
        CHECK_AND_RETHROW(mmu_map(&task->mmu, MMU_SPACE_DATA, i, PAGE_ENTRY(page_idx)));
        TRACE("> %p --> %p", DATA_PAGE_ADDR(i), DATA_PAGE_ADDR(page_idx));
    }

    // TODO: clear bss

    //
    // The task is ready to run
    //
    scheduler_ready_task(task);

cleanup:
    if (IS_ERROR(err)) {
        // free the pages allocated for the process
        for (int i = 0; i < ARRAY_LEN(pages); i++) {
            if (pages[i] != -1) {
                if (i < MAX_PAGE_COUNT) {
                    umem_free_code_page(pages[i]);
                } else {
                    umem_free_data_page(pages[i]);
                }
            }
        }

        // release the task, freeing it as well
        SAFE_RELEASE_TASK(task);
    }
    return err;
}
