#include "task.h"
#include "mem/umem.h"

#include <util/string.h>

#include <stddef.h>
#include <stdbool.h>

typedef struct reg_offset {
    const char* name;
    uint32_t offset;
} reg_offset_t;

static reg_offset_t m_reg_offsets[] = {
    { "LBEG", offsetof(task_regs_t, lbeg) },
    { "LEND", offsetof(task_regs_t, lend) },
    { "LCOUNT", offsetof(task_regs_t, lcount) },
    { "SAR", offsetof(task_regs_t, sar) },
    { "WINDOWBASE", offsetof(task_regs_t, windowbase) },
    { "WINDOWSTART", offsetof(task_regs_t, windowstart) },
    { "PS", offsetof(task_regs_t, ps) },
};

void task_regs_dump(task_regs_t* regs) {
    TRACE("PC=%08x", regs->pc);

    TRACE("");

    for (int i = 0; i < ALIGN_UP(ARRAY_LEN(m_reg_offsets), 4) / 4; i++) {
        printf("[*] ");
        for (int j = 0; j < 4; j++) {
            int idx = i * 4 + j;
            if (idx >= ARRAY_LEN(m_reg_offsets)) break;

            size_t value = *(size_t*)((void*)regs + m_reg_offsets[idx].offset);
            const char* name = m_reg_offsets[idx].name;
            printf("%12s=%08x ", name, value);
        }
        printf("\n\r");
    }

    TRACE("");

    for (int i = 0; i < 4; i++) {
        printf("[*] ");
        for (int j = 0; j < 4; j++) {
            int idx = i * 4 + j;
            printf(" A%02d=%08x", idx, regs->ar[idx]);
        }
        printf("\n\r");
    }

    TRACE("");

    for (int i = 0; i < 64 / 4; i++) {
        printf("[*] ");
        for (int j = 0; j < 4; j++) {
            int abs_idx = i * 4 + j;

            int real_idx = abs_idx - regs->windowbase * 4;
            if (real_idx < 0) {
                real_idx = 64 + real_idx;
            }

            printf("AR%02d=%08x ", abs_idx, regs->ar[real_idx]);

            if ((abs_idx % 4) == 3) {
                // check for windowbase/windowstart
                bool ws = (regs->windowstart & (1 << (abs_idx / 4))) != 0;
                bool cw = regs->windowbase == (abs_idx / 4);
                printf("%c%c\n\r", ws ? '<' : ' ', cw ? '=' : ' ');
            }
        }
    }
}

static pid_t m_pid_gen = 0;

task_t* create_task() {
    // allocate the memory
    task_t* task = malloc(sizeof(task_t));
    if (task == NULL) {
        return NULL;
    }

    // zero it out
    memset(task, 0, sizeof(task_t));

    // initialize the uctx
    task->pid = m_pid_gen++;

    // allocate the uctx
    task->ucontext = umem_alloc_data_page();
    memset(task->ucontext, 0, sizeof(task_ucontext_t));

    return task;
}
