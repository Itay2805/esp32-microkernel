#pragma once

#include <stdint.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Syscalls ABI
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define SYSCALL_NUM     2
#define SYSCALL_RET     2

#define SYSCALL_ARG1    6
#define SYSCALL_ARG2    3
#define SYSCALL_ARG3    4
#define SYSCALL_ARG4    5
#define SYSCALL_ARG5    8
#define SYSCALL_ARG6    9

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Syscalls
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum syscall {
    //
    // ABI syscalls
    //
    SYSCALL_SPILL           = 0x00,
    SYSCALL_XTENSA          = 0x01,
    // 0x02
    // 0x03
    // 0x04
    // 0x05
    // 0x06
    // 0x07

    //
    // kernel only
    //

    SYSCALL_SCHED_PARK      = 0x08,
    SYSCALL_SCHED_YIELD     = 0x09,
    SYSCALL_SCHED_DROP      = 0x0a,
} syscall_t;

static inline uint32_t syscall0(syscall_t syscall) {
    register int a2 asm("a2") = syscall;
    __asm__ volatile ("SYSCALL" : "+r"(a2) :: "memory");
    return a2;
}
