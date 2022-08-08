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

typedef enum task_status {
    /**
     * Means this thread was just allocated and has not
     * yet been initialized
     */
    TASK_STATUS_IDLE = 0,

    /**
     * Means this thread is on a run queue. It is
     * not currently executing user code.
     */
    TASK_STATUS_RUNNABLE = 1,

    /**
     * Means this thread may execute user code.
     */
    TASK_STATUS_RUNNING = 2,

    /**
     * Means this thread is blocked in the runtime.
     * It is not executing user code. It is not on a run queue,
     * but should be recorded somewhere so it can be scheduled
     * when necessary.
     */
    TASK_STATUS_WAITING = 3,

    /**
     * Means the thread stopped itself for a suspend
     * preemption. IT is like THREAD_STATUS_WAITING, but
     * nothing is yet responsible for readying it. some
     * suspend must CAS the status to THREAD_STATUS_WAITING
     * to take responsibility for readying this thread
     */
    TASK_STATUS_PREEMPTED = 4,

    /**
     * Means this thread is currently unused. It may be
     * just exited, on a free list, or just being initialized.
     * It is not executing user code.
     */
    TASK_STATUS_DEAD = 5,

    /**
     * Indicates someone wants to suspend this thread (probably the
     * garbage collector).
     */
    TASK_SUSPEND = 0x1000,
} task_status_t;

/**
 * The task regs are used to save the full context of a
 * task, and are also used during exception handling
 *
 * NOTE: Do not change anything in this struct, we have assembly
 *       code that hardcodes these offsets.
 */
typedef struct task_regs {
    uint32_t ar[64];        // 0
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

    // the task name
    char name[64];

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

    // The current status of the task
    task_status_t status;

    // Link for the scheduler
    struct task* sched_link;

    // The user context of the thread, contains
    // the registers as well
    task_ucontext_t* ucontext;
} task_t;

task_t* create_task();

void release_task(task_t* task);

#define SAFE_RELEASE_TASK(task) \
    do { \
        if (task != NULL) { \
            release_task(task); \
            task = NULL; \
        } \
    } while (0)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Task status
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Get the status of a task atomically
 *
 * @param thread    [IN] The target task
 */
task_status_t get_task_status(task_t* thread);

/**
 * Compare and swap the thread state atomically
 *
 * @remark
 * This will suspend until the thread status is equals to old and only then try to
 * set it to new, if that fails it will continue to try until it has a success.
 *
 * @param thread    [IN] The target thread
 * @param old       [IN] The old status
 * @param new       [IN] The new status
 */
void cas_task_state(task_t* task, task_status_t old, task_status_t new);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Task context
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void save_task_context(task_t* task, task_regs_t* regs);

void restore_task_context(task_t* task, task_regs_t* regs);
