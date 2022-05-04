#pragma once

#include <stdint.h>
#include "drivers/pid.h"

#define CPU_COUNT 2

typedef struct per_cpu_context {
    // Timestamp for LRU of pids
    uint64_t next_stamp;

    pid_binding_t pid_bindings[PID_BINDING_COUNT];

    // currently active pid
    pid_binding_t* primary_binding;
} per_cpu_context_t;

/**
 * The per-cpu context, accessible as a global array
 */
extern per_cpu_context_t g_per_cpu_context[CPU_COUNT];

/**
 * The cpu context for the current cpu
 */
per_cpu_context_t* get_cpu_context();
