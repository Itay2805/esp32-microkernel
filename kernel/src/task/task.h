#pragma once

#include <drivers/dport.h>
#include <mem/mem.h>

#include <stdint.h>
#include "task_regs.h"

/**
 * Represents a pid, we are going to limit
 * to 255 because it is more than we are going
 * to be able to handle efficiently
 */
typedef int8_t pid_t;

/**
 * The task context is essentially the stack
 * and the ipc buffer that is given for the
 * user task, usermode can modify it as much
 * as it wishes, and it is always mapped at
 * the end of the user data segment
 */
typedef struct task_ucontext {
    // the stack for userspace
    char stack[4096];

    // TODO: anything else goes here
} PACKED task_ucontext_t;
STATIC_ASSERT(sizeof(task_ucontext_t) <= USER_PAGE_SIZE);

/**
 * The task regs are used to save the full context of a
 * task, and are also used during exception handling
 *
 * NOTE: Do not change anything in this struct, we have assembly
 *       code that hardcodes these offsets.
 */
typedef struct task_regs {
    size_t ar[64];      // 0-252
    size_t sar;         // 256
    size_t lbeg;        // 260
    size_t lend;        // 264
    size_t lcount;      // 268
    size_t pc;          // 272
    size_t ps;          // 276
    size_t windowbase;  // 280
    size_t windowstart; // 284
} task_regs_t;
STATIC_ASSERT(offsetof(task_regs_t, sar) == TASK_REGS_SAR);
STATIC_ASSERT(offsetof(task_regs_t, lbeg) == TASK_REGS_LBEG);
STATIC_ASSERT(offsetof(task_regs_t, lend) == TASK_REGS_LEND);
STATIC_ASSERT(offsetof(task_regs_t, lcount) == TASK_REGS_LCOUNT);
STATIC_ASSERT(offsetof(task_regs_t, pc) == TASK_REGS_PC);
STATIC_ASSERT(offsetof(task_regs_t, ps) == TASK_REGS_PS);
STATIC_ASSERT(offsetof(task_regs_t, windowbase) == TASK_REGS_WINDOWBASE);
STATIC_ASSERT(offsetof(task_regs_t, windowstart) == TASK_REGS_WINDOWSTART);
STATIC_ASSERT(sizeof(task_regs_t) == TASK_REGS_SIZE);

/**
 * The task struct, used to represent a single task
 */
typedef struct task {
    // the actual pid of the process
    pid_t pid;

    // the mmu context for this task,
    // this handles everything from pid
    // allocation to the peripheral access
    mmu_t mmu;

    // The user context of the thread
    task_ucontext_t* ucontext;

    // the context of the task
    task_regs_t regs;
} task_t;

task_t* create_task();

void task_free(task_t* task);

#define SAFE_TASK_FREE(task) \
    do { \
        if (task != NULL) { \
            task_free(task); \
            task = NULL; \
        } \
    } while (0)
