#include "task.h"
#include "syscall.h"
#include "scheduler.h"
#include "mem/umem.h"

static err_t get_user_ptr(uintptr_t user_ptr, size_t user_size, void** ptr) {
    err_t err = NO_ERROR;

    // TODO: check no page boundary crossing
    // TODO: check in the range

    // convert by getting the page index and
    // convert it to the physical index,
    // converting back to a full address
    task_t* task = get_current_task();
    int idx = DATA_PAGE_INDEX(user_ptr);
    *ptr = (void*)DATA_PAGE_ADDR(task->mmu.dmmu.entries[idx].phys);

cleanup:
    return err;
}

void common_syscall_handler(task_regs_t* regs) {
    err_t err = NO_ERROR;

    // get the syscall number and set the default return to 0
    uint32_t syscall_num = regs->ar[SYSCALL_NUM];
    regs->ar[SYSCALL_RET] = 0;

    // handle the syscall
    switch (syscall_num) {
        // scheduling related syscalls
        case SYSCALL_SCHED_PARK: scheduler_on_park(regs); break;
        case SYSCALL_SCHED_YIELD: scheduler_on_schedule(regs); break;
        case SYSCALL_SCHED_DROP: scheduler_on_drop(regs); break;

        // misc syscalls
        case SYSCALL_LOG: {
            // resolve arguments
            void* str_ptr = NULL;
            size_t str_len = regs->ar[SYSCALL_ARG2];
            CHECK_AND_RETHROW(get_user_ptr(regs->ar[SYSCALL_ARG1], str_len, &str_ptr));

            // print it
            TRACE("%.64s: %.*s", get_current_task()->ucontext->name, str_len, str_ptr);
        } break;

        default:
            CHECK_FAIL_ERROR(ERROR_INVALID_SYSCALL, "unknown syscall %d", regs->ar[2]);
    }

cleanup:
    // if we had an error set it manually to the error
    if (IS_ERROR(err)) {
        regs->ar[SYSCALL_RET] = -err;
    }
}

