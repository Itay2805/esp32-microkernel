
#include <drivers/dport.h>

#include <util/trace.h>
#include "arch/intrin.h"
#include "drivers/pid.h"
#include "mem/mem.h"
#include "arch/cpu.h"
#include "drivers/rtc_cntl.h"
#include "drivers/timg.h"

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
    ASSERT(get_cpu_index() == 0);

    // initialize all the basic dport config
    init_dport();

    // init the mmu and pid units for operation
    init_mmu();
    init_pid();

    // initialize the kernel allocator
    CHECK_AND_RETHROW(init_mem());

    // enable interrupts
    __WSR(INTENABLE, 0b111111);
    __rsync();

    // setup the scheduler
    init_wdt();

    TRACE("We are done here");
cleanup:
    ASSERT(!IS_ERROR(err));
    while(1);
}
