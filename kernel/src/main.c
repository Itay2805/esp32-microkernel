
#include <drivers/dport.h>

#include <util/trace.h>
#include "arch/intrin.h"
#include "drivers/pid.h"
#include "mem/mem.h"

/**
 * The stacks for each cpu
 */
static char m_pro_cpu_stack[4096] = { 0 };
static char m_app_cpu_stack[4096] = { 0 };

/**
 * Array of the kernel stack ptrs,
 * for use in exception handlers
 */
void* g_kernel_stacks[2] = {
    m_pro_cpu_stack + sizeof(m_pro_cpu_stack),
    m_app_cpu_stack + sizeof(m_app_cpu_stack),
};

void kmain() {
    err_t err = NO_ERROR;
    TRACE("Hello from kernel!");

    // make sure we are running from the pro cpu
    ASSERT(__prid() == 0);

    // start with basic init
    init_dport();
    init_mmu();
    init_pid();

    CHECK_AND_RETHROW(init_mem());

    TRACE("%d", __read_ps().packed);

    asm ("ill");

    TRACE("We are done here");
cleanup:
    ASSERT(!IS_ERROR(err));
    while(1);
}
