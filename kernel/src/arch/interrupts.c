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

void* xthal_memcpy(void *dst, const void *src, unsigned len);

typedef enum opcode_format {
    XTENSA_RRR,
    XTENSA_RRI4,
    XTENSA_RRI8,
    XTENSA_RI16,
    XTENSA_RSR,
    XTENSA_CALL,
    XTENSA_CALLX,
    XTENSA_BRI8,
    XTENSA_BRI12,
    XTENSA_RRRN,
    XTENSA_RI7,
    XTENSA_RI6,
} opcode_format_t;

typedef union xtensa_opcode {
    uint8_t op0 : 4;
    struct {
        uint8_t op0 : 4;
        uint8_t t : 4;
        uint8_t s : 4;
        uint8_t r : 4;
        uint8_t imm8;
    } rri8;
    uint32_t value;
} PACKED xtensa_opcode_t;

static void print_opcodes(void* ptr, int32_t len) {
    while (len > 0) {
        xtensa_opcode_t opcode = { .value = 0 };
        xthal_memcpy(&opcode, ptr, 3);

        printf("[-] %08x: ", ptr);

        switch (opcode.op0) {
            case 0b0010: {
                switch (opcode.rri8.r) {
                    case 0b0010: printf("L32I a%d, a%d, %u", opcode.rri8.t, opcode.rri8.s, opcode.rri8.imm8); len += 3; break;
                    default: printf("Invalid opcode %08x", opcode.value); len -= 3; break;
                }
            } break;
            default: printf("Invalid opcode %08x", opcode.value); len -= 3; break;
        }

        printf("\n\r");
    }
}

void common_exception_handler(task_regs_t* regs) {
    int cause = __RSR(EXCCAUSE);

    wdt_disable();

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
        printf("\n\r");
    }

    printf("\n\r");

    // TODO: translate if has mmu
    print_opcodes((void*)regs->pc, 16);
    ERROR("");

    // dump everything
    task_regs_dump(regs);

    // TODO: kill the task that caused the problem

    while(1);
}

void common_interrupt_handler(task_regs_t* regs) {
    // special case for scheduler
    if (wdt_handle()) {
        scheduler_on_schedule(regs);
    } else {
        dport_log_interrupt();
    }
}
