#pragma once

#include <stdint.h>
#include <stddef.h>

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
    // Normal syscalls
    //

    SYSCALL_SCHED_PARK      = 0x08,
    SYSCALL_SCHED_YIELD     = 0x09,
    SYSCALL_SCHED_DROP      = 0x0a,
    // 0x0b
    // 0x0c
    // 0x0d
    // 0x0e
    SYSCALL_LOG             = 0x0f,
} syscall_t;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Syscall helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static inline uint32_t syscall0(syscall_t syscall) {
    register int a2 asm("a2") = syscall;
    __asm__ volatile ("SYSCALL" : "+r"(a2) :: "memory");
    return a2;
}

static inline uint32_t syscall2(syscall_t syscall, size_t arg0, size_t arg1) {
    register int a2 asm("a2") = syscall;
    register int a6 asm("a6") = arg0;
    register int a3 asm("a3") = arg1;
    __asm__ volatile ("SYSCALL" : "+r"(a2) : "r"(a6), "r"(a3) : "memory");
    return a2;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wrappers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static inline void sys_sched_park() {
    syscall0(SYSCALL_SCHED_PARK);
}

static inline void sys_sched_yield() {
    syscall0(SYSCALL_SCHED_YIELD);
}

static inline void sys_sched_drop() {
    syscall0(SYSCALL_SCHED_DROP);
}

static inline void sys_log(const char* str, size_t size) {
    syscall2(SYSCALL_LOG, (uintptr_t)str, size);
}
