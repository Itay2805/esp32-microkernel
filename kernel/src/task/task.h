#pragma once

#include <drivers/dport.h>
#include <mem/mem.h>

#include <stdint.h>
#include "task_regs.h"
#include "arch/intrin.h"

/**
 * Represents a pid, we are going to limit
 * to 255 because it is more than we are going
 * to be able to handle efficiently
 */
typedef int8_t pid_t;

/**
 * The task regs are used to save the full context of a
 * task, and are also used during exception handling
 *
 * NOTE: Do not change anything in this struct, we have assembly
 *       code that hardcodes these offsets.
 */
typedef struct task_regs {
    uint32_t ar[64];        // 0-252
    uint32_t sar;           // 256
    uint32_t lbeg;          // 260
    uint32_t lend;          // 264
    uint32_t lcount;        // 268
    uint32_t pc;            // 272
    ps_t ps;                // 276
    uint32_t windowbase;    // 280
    uint32_t windowstart;   // 284
    uint16_t windowmask;    // 288
    uint16_t windowsize;    // 190
    // TODO: save additional registers so they
    //       won't affect the kernel
} task_regs_t;
STATIC_ASSERT(offsetof(task_regs_t, sar) == TASK_REGS_SAR);
STATIC_ASSERT(offsetof(task_regs_t, lbeg) == TASK_REGS_LBEG);
STATIC_ASSERT(offsetof(task_regs_t, lend) == TASK_REGS_LEND);
STATIC_ASSERT(offsetof(task_regs_t, lcount) == TASK_REGS_LCOUNT);
STATIC_ASSERT(offsetof(task_regs_t, pc) == TASK_REGS_PC);
STATIC_ASSERT(offsetof(task_regs_t, ps) == TASK_REGS_PS);
STATIC_ASSERT(offsetof(task_regs_t, windowbase) == TASK_REGS_WINDOWBASE);
STATIC_ASSERT(offsetof(task_regs_t, windowstart) == TASK_REGS_WINDOWSTART);
STATIC_ASSERT(offsetof(task_regs_t, windowmask) == TASK_REGS_WINDOWMASK);
STATIC_ASSERT(sizeof(task_regs_t) == TASK_REGS_SIZE);

void task_regs_dump(task_regs_t* regs);

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

    // the registers of this thread, we don't care about storing them in this
    // page instead of the kernel heap because it is going to be saved on every
    // context switch anyways, and it might be a cool way to do exception handling
    task_regs_t regs;
} PACKED task_ucontext_t;
STATIC_ASSERT(sizeof(task_ucontext_t) <= USER_PAGE_SIZE);

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

    // The user context of the thread, contains
    // the registers as well
    task_ucontext_t* ucontext;
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
