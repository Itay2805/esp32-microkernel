
#include <task/task_regs.h>

/**
 * this is going to save the full context of the caller
 * to the stack, this should be done if we are going to
 * call into C code to do stuff instead of doing it
 * with assembly and we know what we touch
 *
 * assume that original a0 and a1 are stored and that
 * sp has a valid kernel stack for us to use
 */
.type save_full_interrupt_context,@function
.align  4
.literal_position
.align  4
save_full_interrupt_context:
    # save all a3-a16 regs
    s32i a3,  sp, TASK_REGS_AR(3)
    s32i a4,  sp, TASK_REGS_AR(4)
    s32i a5,  sp, TASK_REGS_AR(5)
    s32i a6,  sp, TASK_REGS_AR(6)
    s32i a7,  sp, TASK_REGS_AR(7)
    s32i a8,  sp, TASK_REGS_AR(8)
    s32i a9,  sp, TASK_REGS_AR(9)
    s32i a10, sp, TASK_REGS_AR(10)
    s32i a11, sp, TASK_REGS_AR(11)
    s32i a12, sp, TASK_REGS_AR(12)
    s32i a13, sp, TASK_REGS_AR(13)
    s32i a14, sp, TASK_REGS_AR(14)
    s32i a15, sp, TASK_REGS_AR(15)

    # save ps and pc
    rsr.epc1 a2
    s32i a2, sp, TASK_REGS_PC
    rsr.ps a2
    s32i a2, sp, TASK_REGS_PS

    # save sar
    rsr.sar a2
    s32i a2, sp, TASK_REGS_SAR

    # save loop regs
    rsr.lbeg a2
    s32i a2, sp, TASK_REGS_LBEG
    rsr.lend a2
    s32i a2, sp, TASK_REGS_LEND
    rsr.lcount a2
    s32i a2, sp, TASK_REGS_LCOUNT

    #
    # make sure that WOE is enabled
    # so any spilling that need to
    # happen will happen, this is
    # needed later on anyways
    #
    rsr.ps a3

    # turn off EXCM
    movi a2, ~(1 << 4)
    and a3, a3, a2

    # turn on WOE
    movi a2, 1 << 18
    or a3, a3, a2

    wsr.ps a3
    rsync

    #
    # spill the windowbase and windowstart
    #
    rsr.windowbase a2
    s32i a2, sp, TASK_REGS_WINDOWBASE
    rsr.windowstart a2
    s32i a2, sp, TASK_REGS_WINDOWSTART

    # spill all the registers
    # TODO: spill everything properly

    # return normally
    ret
.size save_full_interrupt_context, . - save_full_interrupt_context

.type restore_full_interrupt_context,@function
.align  4
.literal_position
.align  4
restore_full_interrupt_context:
    # TODO: restore the full spill ????

    #
    # restore the window, this is tricky since we need
    # to preserve two registers, the sp and the ar0
    #

    # start by saving the sp in excsave1 and a0 in epc1
    wsr.excsave1 sp
    wsr.epc1 a0

    # now switch it
    l32i a2, sp, TASK_REGS_WINDOWBASE
    l32i a3, sp, TASK_REGS_WINDOWSTART
    wsr.windowstart a3
    wsr.windowbase a2
    rsync

    # restore the return and the stack pointer
    rsr.excsave1 sp
    rsr.epc1 a0

    # now restore all the spill area
    # TODO: restore spill

    # restore the PC and PS
    l32i a2, sp, TASK_REGS_PC
    wsr.epc1 a2
    l32i a2, sp, TASK_REGS_PS
    wsr.ps a2

    # restore shift reg
    l32i a2, sp, TASK_REGS_SAR
    wsr.sar a2

    # restore loop regs
    l32i a2, sp, TASK_REGS_LBEG
    wsr.lbeg a2
    l32i a2, sp, TASK_REGS_LEND
    wsr.lend a2
    l32i a2, sp, TASK_REGS_LCOUNT
    wsr.lcount a2

    # restore all normal regs
    l32i a3, sp, TASK_REGS_AR(3)
    l32i a4, sp, TASK_REGS_AR(4)
    l32i a5, sp, TASK_REGS_AR(5)
    l32i a6, sp, TASK_REGS_AR(6)
    l32i a7, sp, TASK_REGS_AR(7)
    l32i a8, sp, TASK_REGS_AR(8)
    l32i a9, sp, TASK_REGS_AR(9)
    l32i a10, sp, TASK_REGS_AR(10)
    l32i a11, sp, TASK_REGS_AR(11)
    l32i a12, sp, TASK_REGS_AR(12)
    l32i a13, sp, TASK_REGS_AR(13)
    l32i a14, sp, TASK_REGS_AR(14)
    l32i a15, sp, TASK_REGS_AR(15)

    # finally rsync it all to make sure that
    # everything is updated
    rsync

    # return normally
    ret
.size restore_full_interrupt_context, . - restore_full_interrupt_context

/***********************************************************************************************************************
 * Normal exception handler, this calls an exception handler routine that will handle
 * specifically exceptions that were raised
 **********************************************************************************************************************/
.global common_exception_entry
.type common_exception_entry,@function
.align  4
.literal_position
.align  4
common_exception_entry:
    # spill the full context
    call0 save_full_interrupt_context

    # now call the common interrupt handler with
    # the task_regs_t
    mov a6, sp
    call4 common_exception_handler

    # restore the context that we saved
    call0 restore_full_interrupt_context

    # TODO: confirm PID

    # finish up by restoring a0-a2 and finally
    # return from the exception, a1 must be restored
    # last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a1, sp, TASK_REGS_AR(1)
    rfe
.size common_exception_entry, . - common_exception_entry

/***********************************************************************************************************************
 * Normal interrupt handler, this calls an exception handler routine that will handle
 * specifically exceptions that were raised
 **********************************************************************************************************************/
.global common_interrupt_entry
.type common_interrupt_entry,@function
.align  4
.literal_position
.align  4
common_interrupt_entry:
    # spill the full context
    call0 save_full_interrupt_context

    # now call the common interrupt handler with
    # the task_regs_t
    mov a6, sp
    call4 common_interrupt_handler

    # restore the context that we saved
    call0 restore_full_interrupt_context

    # TODO: confirm PID

    # finish up by restoring a0-a2 and finally
    # return from the exception, a1 must be restored
    # last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a1, sp, TASK_REGS_AR(1)
    rfe
.size common_interrupt_entry, . - common_interrupt_entry

/***********************************************************************************************************************
 * syscall entry, this calls the syscall handling code
 **********************************************************************************************************************/
.global syscall_entry
.type syscall_entry,@function
.align 4
syscall_entry:
    # start by fixing the nextPC
    rsr.epc1 a0         # skip the syscall instruction
    addi a0, a0, 3

    # check if we need to emulate a loop
    # aka, PC == LEND && LCOUNT != 0
    rsr.lend a2
    bne a0, a2, .skipped_syscall
    rsr.lcount a2
    beqz a2, .skipped_syscall

    # we need to emulate it
    addi a2, a2, -1     # decrement LCOUNT
    wsr.lcount a2
    rsr.lbeg a0         # set the PC to LBEG

.skipped_syscall:
    # actually update the PC
    wsr.epc1 a0

    # TODO: fast IPC path, that won't save everything

    j .slow_path

.fast_path:
    #-------------------------------------------------
    # fast path, check for IPC syscall and
    # small payload
    #-------------------------------------------------

    # TODO: do fast path handling

    # return from the fast path
    j .return_from_syscall

.slow_path:
    #-------------------------------------------------
    # slow path, we are going to call C code,
    # save everything
    #-------------------------------------------------

    # spill the full context
    call0 save_full_interrupt_context

    # now call the common interrupt handler with
    # the task_regs_t
    mov a6, sp
    call4 common_syscall_handler

    # restore the context that we saved
    call0 restore_full_interrupt_context

.return_from_syscall:
    # TODO: confirm PID

    # finish up by restoring a0-a2 and finally
    # return from the exception, a1 must be restored
    # last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a1, sp, TASK_REGS_AR(1)
    rfe
.size syscall_entry, . - syscall_entry