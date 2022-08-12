#include "vdso.h"

#include <syscall.h>

VDSO void task_trampoline(void(*entry)()) {
    entry();
    sys_sched_drop();
}
