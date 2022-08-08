#include "task.h"
#include "mem/umem.h"

#include <util/string.h>

#include <stddef.h>
#include <stdbool.h>
#include <stdatomic.h>

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
    TRACE("BEFORE ALLOC");

    // allocate the memory
    task_t* task = malloc(sizeof(task_t));
    if (task == NULL) {
        return NULL;
    }

    TRACE("ALLOCATED TASK %p", task);

    // zero it out
    memset(task, 0, sizeof(task_t));
    task->status = TASK_STATUS_DEAD;

    // initialize the uctx
    task->pid = m_pid_gen++;

    TRACE("ITS PID IS %d", task->pid);

    // allocate the uctx
    int uctx_page = umem_alloc_data_page();
    TRACE("UCTX PAGE IS AT %d", uctx_page);
    mmu_map_code(&task->mmu, MMU_SPACE_DATA, UCTX_PAGE_INDEX, MMU_SPACE_ENTRY(uctx_page));

    task->ucontext = DATA_PAGE_ADDR(uctx_page);
    TRACE("UCTX ADDRESS IS %p", task->ucontext);
    memset(task->ucontext, 0, sizeof(task_ucontext_t));

    TRACE("SETTING PS");

    // setup the user context
    task->ucontext->regs.ps = (ps_t){
        .excm = 0,
        .intlevel = 0,
        .um = 1,
        .woe = 1
    };

    TRACE("SETTING STACK TO %p", task->ucontext->stack + STACK_SIZE);

    // set the SP to be the end of the stack, which is at the ucontext
    // area at the end
//    task->ucontext->regs.ar[1] = (uint32_t) (DATA_PAGE_ADDR(UCTX_PAGE_INDEX) + offsetof(task_ucontext_t, stack) + STACK_SIZE);
    task->ucontext->regs.ar[1] = (uint32_t) (task->ucontext->stack + STACK_SIZE);

    // set the state as waiting
    cas_task_state(task, TASK_STATUS_DEAD, TASK_STATUS_WAITING);

    return task;
}

void release_task(task_t* task) {
    ASSERT(!"TODO: release_task");
}

task_status_t get_task_status(task_t* thread) {
    return atomic_load(&thread->status);
}

void cas_task_state(task_t* task, task_status_t old, task_status_t new) {
    // sanity
    ASSERT((old & TASK_SUSPEND) == 0);
    ASSERT((new & TASK_SUSPEND) == 0);
    ASSERT(old != new);

    // loop if status is in a suspend state giving the GC
    // time to finish and change the state to old val
    task_status_t old_value = old;
    for (int i = 0; !atomic_compare_exchange_weak(&task->status, &old_value, new); i++, old_value = old) {
        if (old == TASK_STATUS_WAITING && task->status == TASK_STATUS_RUNNABLE) {
            ASSERT(!"Waiting for TASK_STATUS_WAITING but is TASK_STATUS_RUNNABLE");
        }

        // pause for max of 10 times polling for status
        for (int x = 0; x < 10 && task->status != old; x++) {
            asm("":::"memory");
        }
    }
}

void save_task_context(task_t* task, task_regs_t* regs) {
    task->ucontext->regs = *regs;
}

void restore_task_context(task_t* task, task_regs_t* regs) {
    *regs = task->ucontext->regs;
}
