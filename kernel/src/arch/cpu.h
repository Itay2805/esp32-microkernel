#pragma once

#include <drivers/pid.h>
#include <task/task.h>

#include <stdint.h>

#define CPU_COUNT 2

typedef struct per_cpu_context {
    //------------------------------
    // For PID management
    //------------------------------

    // Timestamp for LRU of pids
    uint64_t next_stamp;

    // the per-cpu pid binding
    pid_binding_t pid_bindings[PID_BINDING_COUNT];

    // currently active pid
    pid_binding_t* primary_binding;

    //------------------------------
    // For scheduler
    //------------------------------

    // how many disables we had
    int preempt_disable_depth;

    // the currently running task
    task_t* current_task;
} per_cpu_context_t;

/**
 * The per-cpu context, accessible as a global array
 */
extern per_cpu_context_t g_per_cpu_context[CPU_COUNT];

/**
 * The cpu context for the current cpu
 */
per_cpu_context_t* get_cpu_context();

/**
 * Get the ID of the current cpu, it is always going to
 * be less than CPU_COUNT
 */
uint32_t get_cpu_index();
