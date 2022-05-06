#include "interrupts.h"
#include "task/task.h"
#include "intrin.h"

void common_exception_entry(void);
void common_interrupt_entry(void);
void syscall_entry(void);

void* g_fast_interrupts[64] = {
    // start with everything
    [0 ... 63] = common_exception_entry,

    // override the entry for syscall
    [SyscallCause] = syscall_entry,
};

static const char* m_cause_str[] = {
    [IllegalInstructionCause] = "IllegalInstructionCause",
    [InstructionFetchErrorCause] = "InstructionFetchErrorCause",
    [LoadStoreErrorCause] = "LoadStoreErrorCause",
    [InstrPIFDataErrorCause] = "InstrPIFDataErrorCause",
    [LoadStorePIFDataErrorCause] = "LoadStorePIFDataErrorCause",
    [InstrPIFAddrErrorCause] = "InstrPIFAddrErrorCause",
    [LoadStorePIFAddrErrorCause] = "LoadStorePIFAddrErrorCause",
};

void common_exception_handler(task_regs_t* regs) {
    int cause = __RSR(EXCCAUSE);
    if (cause < ARRAY_LEN(m_cause_str) && m_cause_str[cause] != NULL) {
        TRACE("common_exception_handler(%s): pc = %x, a0 = %x, ps = %x",
              m_cause_str[cause], regs->pc, regs->ar[0], regs->ps);
    } else {
        TRACE("common_exception_handler(%d): pc = %x, a0 = %x, ps = %x",
              cause, regs->pc, regs->ar[0], regs->ps);
    }

    regs->pc += 3;
}

void common_interrupt_handler(task_regs_t* regs) {
    TRACE("common_interrupt_handler: pc = %x, a0 = %x, ps = %x",
          regs->pc, regs->ar[0], regs->ps);
}

void common_syscall_handler(task_regs_t* regs) {
    TRACE("common_syscall_handler(): pc = %x, a0 = %x, ps = %x",
          regs->pc, regs->ar[0], regs->ps);
}
