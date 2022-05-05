#pragma once

#include <stdint.h>
#include "drivers/dport.h"

/**
 * Represents a pid, we are going to limit
 * to 255 because it is more than we are going
 * to be able to handle efficiently
 */
typedef int8_t pid_t;

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
} task_t;
