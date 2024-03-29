
#include <task/task_regs.h>

.section .vdso.text

/**
 * The way interrupt vectors work in xtensa is that there are 64byte between vector entries and
 * it jumps to the constant offset between each of them.
 *
 * This code resides in a user page, and on the first fetch of some of these we will
 * enter pid 0, we need to be extra sure that even if we enter this function from normal
 * control flow nothing happens.
 *
 * qemu xtensa_cpu_do_interrupt codes:
 *  3 - window overflow 4
 *  4 - window underflow 4
 *  5 - window overflow 8
 *  6 - window underflow 8
 *  7 - window overflow 12
 *  8 - window underflow 12
 *  9 - irq
 *  10 - kernel
 *  11 - user
 *  12 - double
 *  13 - debug
 */

/***********************************************************************************************************************
 * Window overflow/underflow, these are pretty simple
 *
 * For these we simply need to spill/load to/from the stack the first x gpregs,
 * we need to use the special rfwo (return from window overflow) and rfwu (return from window underflow)
 * to properly handle these
 **********************************************************************************************************************/

.global vecbase

.align 64
vecbase:
window_overflow_4:
/* window overflow 4 - 0x00 */
    s32e	a0, a5, -16
    s32e	a1, a5, -12
    s32e	a2, a5,  -8
    s32e	a3, a5,  -4
    rfwo

.align 64
window_underflow_4:
/* window underflow 4 - 0x40 */
    l32e	a0, a5, -16
    l32e	a1, a5, -12
    l32e	a2, a5,  -8
    l32e	a3, a5,  -4
    rfwu

.align 64
window_overflow_8:
/* windows overflow 8 - 0x80 */
    s32e	a0, a9, -16
    l32e	a0, a1, -12
    s32e	a1, a9, -12
    s32e	a2, a9, -8
    s32e	a3, a9, -4
    s32e	a4, a0, -32
    s32e	a5, a0, -28
    s32e	a6, a0, -24
    s32e	a7, a0, -20
    rfwo

.align 64
window_underflow_8:
/* windows underflow 8 - 0xc0 */
    l32e	a0, a9, -16
    l32e	a1, a9, -12
    l32e	a2, a9, -8
    l32e	a7, a1, -12
    l32e	a3, a9, -4
    l32e	a4, a7, -32
    l32e	a5, a7, -28
    l32e	a6, a7, -24
    l32e	a7, a7, -20
    rfwu

.align 64
window_overflow_12:
/* windows overflow 12 - 0x100 */
    s32e	a0, a13, -16
    l32e	a0, a1, -12
    s32e	a1, a13, -12
    s32e	a2, a13, -8
    s32e	a3, a13, -4
    s32e	a4, a0, -48
    s32e	a5, a0, -44
    s32e	a6, a0, -40
    s32e	a7, a0, -36
    s32e	a8, a0, -32
    s32e	a9, a0, -28
    s32e	a10, a0, -24
    s32e	a11, a0, -20
    rfwo

.align 64
window_underflow_12:
/* windows underflow 12 - 0x140 */
    l32e	a0, a13, -16
    l32e	a1, a13, -12
    l32e	a2, a13, -8
    l32e	a11, a1, -12
    l32e	a3, a13, -4
    l32e	a4, a11, -48
    l32e	a5, a11, -44
    l32e	a6, a11, -40
    l32e	a7, a11, -36
    l32e	a8, a11, -32
    l32e	a9, a11, -28
    l32e	a10, a11, -24
    l32e	a11, a11, -20
    rfwu

/***********************************************************************************************************************
 * Interrupt levels
 **********************************************************************************************************************/

.align 64
/* interrupt level 2 - 0x180 */
    rsr.excsave2 a0
    rfi 2

.align 64
/* interrupt level 3 - 0x1c0 */
    rsr.excsave3 a0
    rfi 3

.align 64
/* interrupt level 4 - 0x200 */
    rsr.excsave4 a0
    rfi 4

.align 64
/* interrupt level 5 - 0x240 */
    rsr.excsave5 a0
    rfi 5

.align 64
/* interrupt level 6 (debug) - 0x280 */
    rsr.excsave6 a0
    rfi 6

.align 64
/* interrupt level 7 (nmi) - 0x2c0 */
    rsr.excsave7 a0
    rfi 7

/***********************************************************************************************************************
 * Normal exceptions
 **********************************************************************************************************************/

/*
 * kernel exception - 0x300
 * This entry does not actually change the pid to 0, since we expect
 * to already be in kernel mode for this entry, if we were in usermode
 * but it changed PS.UM to 0, we will go here, and once we jump to the
 * kernel we will just fault since we are not in the right entry.
 */
.type  kernel_exception,@function
.align 64
 kernel_exception:
//    // save the original a0 and a1 in two scratch
//    // registers, specifically a1 and a0
//    wsr.excsave1 a1
//    wsr.depc a0
//
//    // allocate the task_regs_t for the current exception
//    addi sp, sp, -TASK_REGS_SIZE
//
//    // now save the original a0-a2, we need
//    // them to do stuff
//    s32i a0, sp, TASK_REGS_AR(0)
//    s32i a1, sp, TASK_REGS_AR(1)
//    s32i a2, sp, TASK_REGS_AR(2)
//    s32i a3, sp, TASK_REGS_AR(3)
//
//    //
//    // we are going to start by loading a fast handler, which
//    // could also be a common slow handler, the idea is that
//    // the fast handler can take a quick path of handling some
//    // of the exception causes.
//    //
//    // it is safe to use exccause as index since it is only 6 bits
//    // meaning that we only haev a max of 64 entries
//    //
//    rsr.exccause a0
//    movi a2, g_fast_interrupts
//    addx4 a0, a0, a2
//    l32i a0, a0, 0
//
//    // jump to it
//    jx a0
    rfe
.size kernel_exception, . - kernel_exception

/*
 * user exception - 0x340
 * This entry does change the pid to 0 unconditionally, so
 * we can assume that now we are in kernel mode and we need
 * to be careful
 */
.type  user_exception,@function
.align 64
user_exception:
    // save the original a0 and a1 in two scratch
    // registers, specifically a1 and a0
    wsr.excsave1 a1
    wsr.depc a0

    // load the kernel stack, we first take
    // the prid of the current cpu, then we
    // are going to access a pointer array
    // and load the stack from it.
    rsr.prid a1
    extui a1, a1, 13, 1
    movi a0, g_kernel_stacks
    addx4 a1, a1, a0
    l32i sp, a1, 0

    // allocate the task_regs_t for the current exception
    addi sp, sp, -TASK_REGS_SIZE

    // now save the original a0-a2, we need
    // them to do stuff
    rsr.depc a0
    s32i a0, sp, TASK_REGS_AR(0)
    rsr.excsave1 a0
    s32i a0, sp, TASK_REGS_AR(1)
    s32i a2, sp, TASK_REGS_AR(2)
    s32i a3, sp, TASK_REGS_AR(3)

    //
    // we are going to start by loading a fast handler, which
    // could also be a common slow handler, the idea is that
    // the fast handler can take a quick path of handling some
    // of the exception causes.
    //
    // it is safe to use exccause as index since it is only 6 bits
    // meaning that we only haev a max of 64 entries
    //
    rsr.exccause a0
    movi a2, g_fast_interrupts
    addx4 a0, a0, a2
    l32i a0, a0, 0

    // jump to it
    jx a0
.size user_exception, . - user_exception

.align 64
/* double exception - 0x380 */
    rfde
