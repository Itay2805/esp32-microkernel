#pragma once

#include <drivers/dport.h>
#include <mem/mem.h>

#include <stdint.h>

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
