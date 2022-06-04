#include <stdbool.h>
#include "interrupts.h"
#include "task/task.h"
#include "intrin.h"
#include "cpu.h"
#include "drivers/timg.h"
#include "task/scheduler.h"

void common_exception_entry(void);
void common_interrupt_entry(void);
void syscall_entry(void);

void* g_fast_interrupts[64] = {
    // start with everything
    [0 ... 63] = common_exception_entry,

    // override the entry for syscall
    [SyscallCause] = syscall_entry,
    [Level1InterruptCause] = common_interrupt_entry,
};

static const char* m_cause_str[] = {
    [IllegalInstructionCause] = "IllegalInstructionCause",
    [SyscallCause] = "SyscallCause",
    [InstructionFetchErrorCause] = "InstructionFetchErrorCause",
    [LoadStoreErrorCause] = "LoadStoreErrorCause",
    [Level1InterruptCause] = "Level1InterruptCause",
    [AllocaCause] = "AllocaCause",
    [IntegerDivideByZero] = "IntegerDivideByZero",
    [PrivilegedCause] = "PrivilegedCause",
    [LoadStoreAlignmentCause] = "LoadStoreAlignmentCause",
    [InstrPIFDataErrorCause] = "InstrPIFDataErrorCause",
    [LoadStorePIFDataErrorCause] = "LoadStorePIFDataErrorCause",
    [InstrPIFAddrErrorCause] = "InstrPIFAddrErrorCause",
    [LoadStorePIFAddrErrorCause] = "LoadStorePIFAddrErrorCause",
    [InstTLBMissCause] = "InstTLBMissCause",
    [InstTLBMultiHitCause] = "InstTLBMultiHitCause",
    [InstFetchPrivilegeCause] = "InstFetchPrivilegeCause",
    [InstFetchProhibitedCause] = "InstFetchProhibitedCause",
    [LoadStoreTLBMissCause] = "LoadStoreTLBMissCause",
    [LoadStoreTLBMultiHitCause] = "LoadStoreTLBMultiHitCause",
    [LoadStorePrivilegeCause] = "LoadStorePrivilegeCause",
    [LoadProhibitedCause] = "LoadProhibitedCause",
    [StoreProhibitedCause] = "StoreProhibitedCause",
    [Coprocessor0Disabled] = "Coprocessor0Disabled",
    [Coprocessor1Disabled] = "Coprocessor1Disabled",
    [Coprocessor2Disabled] = "Coprocessor2Disabled",
    [Coprocessor3Disabled] = "Coprocessor3Disabled",
    [Coprocessor4Disabled] = "Coprocessor4Disabled",
    [Coprocessor5Disabled] = "Coprocessor5Disabled",
    [Coprocessor6Disabled] = "Coprocessor6Disabled",
    [Coprocessor7Disabled] = "Coprocessor7Disabled",

};

void common_exception_handler(task_regs_t* regs) {
    int cause = __RSR(EXCCAUSE);

    // print the cuase
    printf("[-] got exception ");
    if (cause < ARRAY_LEN(m_cause_str) && m_cause_str[cause] != NULL) {
        printf("%s (%d)", m_cause_str[cause], cause);
    } else {
        printf("%d", cause);
    }

    // print the vaddr if needed
    if (
        cause == InstructionFetchErrorCause ||
        cause == LoadStoreErrorCause ||
        cause == LoadStoreAlignmentCause ||
        cause == InstrPIFDataErrorCause ||
        cause == LoadStorePIFDataErrorCause ||
        cause == InstrPIFAddrErrorCause ||
        cause == LoadStorePIFAddrErrorCause ||
        cause == InstTLBMissCause ||
        cause == InstTLBMultiHitCause ||
        cause == InstFetchPrivilegeCause ||
        cause == InstFetchProhibitedCause ||
        cause == LoadStoreTLBMissCause ||
        cause == LoadStoreTLBMultiHitCause ||
        cause == LoadStorePrivilegeCause ||
        cause == LoadProhibitedCause ||
        cause == StoreProhibitedCause
    ) {
        printf(" EXCVADDR=%08x", __RSR(EXCVADDR));
    }

    printf("\n\r");

    // TODO: kill the task that caused the problem
}

void common_interrupt_handler(task_regs_t* regs) {
    // special case for scheduler
    if (wdt_handle()) {
        // save the current task context
        task_t* task = get_current_task();
        if (task != NULL) {
            task->ucontext->regs = *regs;
        }

        // we got a watchdog, do schedule as well
        scheduler_next();

        // restore the registers task
        task = get_current_task();
        if (task != NULL) {
            *regs = task->ucontext->regs;
        } else {
            // there is nothing to run, enter sleep
            wdt_disable();
            asm volatile ("WAITI 0");
            wdt_enable();
        }
    } else {
        TRACE("Got unknown interrupt");
    }
}
