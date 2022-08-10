
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

 __attribute__((aligned(STACK_SIZE)))
char g_pro_cpu_stack[STACK_SIZE] = { 0 };

__attribute__((aligned(STACK_SIZE)))
char g_app_cpu_stack[STACK_SIZE] = { 0 };

/**
 * Array of the kernel stack ptrs,
 * for use in exception handlers
 */
void* g_kernel_stacks[2] = {
    g_pro_cpu_stack + sizeof(g_pro_cpu_stack),
    g_app_cpu_stack + sizeof(g_app_cpu_stack),
};

static void dummy() {
    TRACE("Hello from task `%s`!", get_current_task()->ucontext->name);
    scheduler_park(NULL, NULL);
    while(1);
}

static err_t setup_init(int a) {
    err_t err = NO_ERROR;

    task_t* task = create_task(dummy, "my task %d", a);
    CHECK(task != NULL);
    scheduler_ready_task(task);

cleanup:
    return err;
}

void kmain() {
    err_t err = NO_ERROR;

    // setup the basic state to be ready for action
    ps_t ps = __read_ps();
    ps.excm = 0;        // normal exception mode
    ps.intlevel = 0xF;   // interrupts disabled
    ps.um = 1;          // usermode
    ps.woe = 1;         // window overflow enabled
    __write_ps(ps);

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

    // enable interrupts
    ps = __read_ps();
    ps.intlevel = 0;   // interrupts enabled
    __write_ps(ps);

    // clear all pending interrupts
    __WSR(INTCLEAR, BIT0);

    // enable all interrupt levels
    __WSR(INTENABLE, BIT0);

    // sync all these configurations
    __rsync();

    // setup the init task
    CHECK_AND_RETHROW(setup_init(1));
    CHECK_AND_RETHROW(setup_init(2));

    // init scheduler
    CHECK_AND_RETHROW(init_wdt());
    scheduler_drop_current();

    TRACE("We are done here");
cleanup:
    ASSERT(!IS_ERROR(err));
    while(1);
}
