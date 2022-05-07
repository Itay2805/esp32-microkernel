#include "cpu.h"
#include "intrin.h"

per_cpu_context_t g_per_cpu_context[CPU_COUNT] = {};

/**
 * The cpu context for the current cpu
 */
per_cpu_context_t* get_cpu_context() {
    return &g_per_cpu_context[get_cpu_index()];
}

uint32_t get_cpu_index() {
    // this is taken from esp-idf
    //      cpu_ll_get_core_id
    return (__RSR(PRID) >> 13) & 1;
}
