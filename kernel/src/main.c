
#include <drivers/dport.h>

#include <util/trace.h>
#include "arch/intrin.h"
#include "drivers/pid.h"
#include "mem/mem.h"
#include "arch/cpu.h"
#include "drivers/rtc_cntl.h"
#include "drivers/timg.h"
#include "drivers/uart.h"
#include "task/scheduler.h"

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

    init_uart();
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

    // set the cpu state properly
    //  - normal operation
    //  - interrupts enabled
    //  - usermode
    //  - window exception enabled
    ps_t ps = __read_ps();
    ps.excm = 0;
    ps.intlevel = 0;
    ps.um = 1;
    ps.woe = 1;
    __write_ps(ps);

    // clear all pending interrupts
    __WSR(INTCLEAR, BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5);

    // enable all interrupt levels
    __WSR(INTENABLE, BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5);

    // sync all these configurations
    __rsync();

    // setup the scheduler
    CHECK_AND_RETHROW(init_wdt());

    // drop everything and startup the scheduler
    scheduler_drop_current();

    TRACE("We are done here");
cleanup:
    ASSERT(!IS_ERROR(err));
    while(1);
}
