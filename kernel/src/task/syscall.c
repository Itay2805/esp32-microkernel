#include "task.h"
#include "syscall.h"
#include "scheduler.h"

void common_syscall_handler(task_regs_t* regs) {
    err_t err = NO_ERROR;

    // get the syscall number and set the default return to 0
    uint32_t syscall_num = regs->ar[SYSCALL_NUM];
    regs->ar[SYSCALL_RET] = 0;

    // handle the syscall
    switch (syscall_num) {
        case SYSCALL_SCHED_PARK: scheduler_on_park(regs); break;
        case SYSCALL_SCHED_YIELD: scheduler_on_schedule(regs); break;
        case SYSCALL_SCHED_DROP: scheduler_on_drop(regs); break;
        default: TRACE("unknown syscall %d", regs->ar[2]);
    }

cleanup:
    // if we had an error set it manually to the error
    if (IS_ERROR(err)) {
        regs->ar[SYSCALL_RET] = -err;
    }
}

