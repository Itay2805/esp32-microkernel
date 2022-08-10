
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
    // save ps and pc
    rsr.epc1 a2
    s32i a2, sp, TASK_REGS_PC
    rsr.ps a2
    s32i a2, sp, TASK_REGS_PS

    // save sar
    rsr.sar a2
    s32i a2, sp, TASK_REGS_SAR

    // save loop regs
    rsr.lbeg a2
    s32i a2, sp, TASK_REGS_LBEG
    rsr.lend a2
    s32i a2, sp, TASK_REGS_LEND
    rsr.lcount a2
    s32i a2, sp, TASK_REGS_LCOUNT

    //
    // save the orig window base/start
    //
    rsr.windowbase a2
    rsr.windowstart a3
    s32i a2, sp, TASK_REGS_WINDOWBASE
    s32i a3, sp, TASK_REGS_WINDOWSTART

    //
    // spill all the registers
    //
    // this may seem complex but is actually really simple:
    //
    // 1. we are going to start by aligning our windowstart with the windowbase,
    //    by doing a rotr16 on it, this will make it easier to figure out which
    //    frames need to be saved later on
    // 2. save a4-a15, if we detect that in one of the 3 ranges we have a live range
    //    we are going to skip saving the rest and use the spill loop (stage 3)
    // 3. we are going to figure how much frames should be kept, that is done in couple steps:
    //       a. clear the first bit representing the current range
    //       b. keep only the first set bit
    //       c. count trailing zeros + 1
    //    that essentially gives us the depth of the register stack as it is
    // 4. go in a loop and rotate the window backwards, saving 4 registers at a time
    // 5. restore the window base/start
    //
    // We are also going to store the lower 4 bits of the rotated window and
    // the amount of frames that need to be saved in a special windowmask entry
    // in our task_regs_t. (will be saved as 2 16bit values)
    //

    // save the windowstart for later use
    wsr.excsave1 a3

    // 1. rotate the windowstart, we also going to use SAR
    //    as means to actually save the windowbase for when
    //    we want to restore it later on after the spilling
    ssr a2
    slli a2, a3, 32 - 16
    src a2, a3, a2
    srli a2, a2, 32 - 16
    s16i a2, sp, TASK_REGS_WINDOWMASK

    // 2. save live registers, we are going to branch out
    //    to full spill if there is an overflow

    bbsi a2, 1, .full_spill
    s32i a4, sp, TASK_REGS_AR(4)
    s32i a5, sp, TASK_REGS_AR(5)
    s32i a6, sp, TASK_REGS_AR(6)
    s32i a7, sp, TASK_REGS_AR(7)

    bbsi a2, 2, .full_spill
    s32i a8, sp, TASK_REGS_AR(8)
    s32i a9, sp, TASK_REGS_AR(9)
    s32i a10, sp, TASK_REGS_AR(10)
    s32i a11, sp, TASK_REGS_AR(11)

    bbsi a2, 3, .full_spill
    s32i a12, sp, TASK_REGS_AR(12)
    s32i a13, sp, TASK_REGS_AR(13)
    s32i a14, sp, TASK_REGS_AR(14)
    s32i a15, sp, TASK_REGS_AR(15)

    // lastly check if there are even more frames, if not we
    // don't need to spill anything else
    bnei a2, 1, .full_spill
    j .done_spill

.full_spill:
    //
    // 3. figure out how many frames we need to keep
    //

    // a. turn off the first bit, we can assume that the first bit
    //    is always set, so just subtracting one will work fine
    addi a3, a2, -1

    // b. negate the number, and then and it with the version that does have
    //    the first bit set, this will make sure that the only bit that stays
    //    is the first one, if it was set, especially after we cleared it in
    //    the previous instruction
    neg a3, a3
    and a3, a3, a2

    // c. count trailing zeros + 1, we have the NSAU instruction
    //    that does exactly that, we just need to subtract 15
    //    since we want the +1 and ws is only 16 bits, so we don't
    //    need that big of a number
    nsau a2, a3
    addi a2, a2, -15

    // store the window frame count in the windowsize
    s16i a2, sp, TASK_REGS_WINDOWSIZE

    // 4. we are now ready to the rest of the spilling
    //    because we are going backwards we also need to do
    //    the storing backwards, so the register window in
    //    memory will make sense, so we store from the end
    //    and each iteration move the base backwards so it
    //    stays the same offset

.spill_loop:
    // rotate the window backwards, we will now have our
    // stack pointer at a5 instead
    rotw -1
    s32i a0, a5, TASK_REGS_AR_END - 16
    s32i a1, a5, TASK_REGS_AR_END - 12
    s32i a2, a5, TASK_REGS_AR_END - 8
    s32i a3, a5, TASK_REGS_AR_END - 4

    // decrement the count, it is now in a6
    addi a2, a6, -1

    // we are going to move 16 bytes backwards
    addi a1, a5, -16

    // If we reached zero we are done
    bnez a2, .spill_loop

    // now set correctly the windowbase and windowstart
    // we moved around to spill everything, and now that we
    // are done spilling we are going to set the windowstart
    // to 1 shift the windowbase, and we are going to set
    // the windowbase as it was before, this will essentially
    // clear everything but keep the a0 and a1 as they were at the start
    rsr.sar a2
    movi a3, 1
    ssl a2      // Set Shift Amount for Left Shift
    sll a3, a3  // Shift Left Logical
    wsr.windowstart a3
    wsr.windowbase a2
    rsync

.done_spill:

    // return normally
    ret
.size save_full_interrupt_context, . - save_full_interrupt_context

/**
 * Just like the save_full_interrupt_context, this is going to take an entire
 * task_regs_t context that was saved on exception or modified by the kernel and
 * restore it to continue from the exception
 */
.type restore_full_interrupt_context,@function
.align  4
.literal_position
.align  4
restore_full_interrupt_context:
    //
    // restore the window, this is tricky since we need
    // to preserve two registers, the sp and the ar0
    //

    // start by saving the sp in excsave1 and a0 in epc1
    wsr.excsave1 sp
    wsr.epc1 a0

    // now switch it
    l32i a2, sp, TASK_REGS_WINDOWBASE
    l32i a3, sp, TASK_REGS_WINDOWSTART
    wsr.windowstart a3
    wsr.windowbase a2
    rsync

    // restore the return and the stack pointer
    rsr.excsave1 sp
    rsr.epc1 a0

    // put the original windowbase in excsave1
    // as we will need it to calculate how many
    // regs to clear
    wsr.excsave1 a2

    //
    // now we need to restore all the spill area
    //

    // load the window size, aka the count we need to restore
    // this was calculated when we last spilled for ease of use
    l16ui a2, sp, TASK_REGS_WINDOWSIZE

    // skip the current frame, it will be restored later on
    rotw -1

    // check if we need to actually restore anything
    beqz a6, .zero_regs

    // TODO: why are we allowed to do this?
    mov a2, a6
    mov a3, a5

    // to understand this loop it is the best to read the documentation at the
    // spill function, we do essentially the same just backwards
.restore_loop:
    // go backwards one
    rotw -1

    // set the task_regs offset and decrement
    // the count, do it before we load the correct regs
    addi a3, a7, -16
    addi a2, a6, -1

    // load all the registers
    l32i a4, a3, TASK_REGS_AR_END
    l32i a5, a3, TASK_REGS_AR_END + 4
    l32i a6, a3, TASK_REGS_AR_END + 8
    l32i a7, a3, TASK_REGS_AR_END + 12

    // If we reached zero we are done
    bnez a2, .restore_loop

.zero_regs:
    // we restored everything that we need to restore, now clear
    // the rest of the registers so nothing will get leaked from
    // the kernel to the user

    // calculate how many registers we need to clear by doing:
    //   windowbase - original_windowbase
    // If it is zero it means there is nothing to clear
    rsr.windowbase a0
    rsr.excsave1 a3
    sub a3, a0, a3
    beqz a3, .done_zeroing_regs

    // only take the bits we care about, in case it
    // got an underflow
    extui a3, a3, 0, 4

.zero_loop:
    // just like the normal restore loop, but
    // we are going to just set it to zero in here
    // instead of loading it from the task_regs
    rotw -1

    // decrement loop count
    addi a3, a7, -1

    // zero the regs
    movi a4, 0
    movi a5, 0
    movi a6, 0
    movi a7, 0

    // go until we reach the frame we started at,
    // so until we reach 1
    bgei a3, 1, .zero_loop

.done_zeroing_regs:
    // we are now back to where we were, we can
    // continue and restore whatever else we need
    // to restore

    // restore the PC and PS
    l32i a2, sp, TASK_REGS_PC
    wsr.epc1 a2
    l32i a2, sp, TASK_REGS_PS
    wsr.ps a2

    // restore shift reg
    l32i a2, sp, TASK_REGS_SAR
    wsr.sar a2

    // restore loop regs
    l32i a2, sp, TASK_REGS_LBEG
    wsr.lbeg a2
    l32i a2, sp, TASK_REGS_LEND
    wsr.lend a2
    l32i a2, sp, TASK_REGS_LCOUNT
    wsr.lcount a2

    // we are done restoring everything else, lets
    // finish by restoring the rest of the 16 original
    // registers that we have not restored yet, we are
    // going to use the mask just like we do in the spilling
    l16ui a2, sp, TASK_REGS_WINDOWMASK

    bbsi a2, 1, .done_restore_regs
    l32i a4, sp, TASK_REGS_AR(4)
    l32i a5, sp, TASK_REGS_AR(5)
    l32i a6, sp, TASK_REGS_AR(6)
    l32i a7, sp, TASK_REGS_AR(7)

    bbsi a2, 2, .done_restore_regs
    l32i a8, sp, TASK_REGS_AR(8)
    l32i a9, sp, TASK_REGS_AR(9)
    l32i a10, sp, TASK_REGS_AR(10)
    l32i a11, sp, TASK_REGS_AR(11)

    bbsi a2, 3, .done_restore_regs
    l32i a12, sp, TASK_REGS_AR(12)
    l32i a13, sp, TASK_REGS_AR(13)
    l32i a14, sp, TASK_REGS_AR(14)
    l32i a15, sp, TASK_REGS_AR(15)

.done_restore_regs:
    // the last a0-a3 regs will be manually restored
    // later on just before we call the rfe instruction

    // finally rsync it all to make sure that
    // everything is updated
    rsync

    // return normally
    ret
.size restore_full_interrupt_context, . - restore_full_interrupt_context

/**
 * While running in the kernel we want to enable the exception mode
 * and enable the use of the register window, but while we are doing
 * restore work we don't want this to happen, and we want the rotate
 * window to just rotate
 */
enable_kernel_exceptions:
    // set WOE = 1
    //     INTLEVEL = 1
    movi a2, (1 << 18) | 0xf
    wsr.ps a2
    rsync
    ret

/**
 * This sets the kernel exception handling
 * so we can do proper restore
 */
disable_kernel_exceptions:
    // set EXCM = 1
    movi a2, (1 << 4) | 0xf
    wsr.ps a2
    rsync
    ret

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
    // spill the full context
    call0 save_full_interrupt_context

    // enable exceptions for C code
    call0 enable_kernel_exceptions

    // now call the common interrupt handler with
    // the task_regs_t
    mov a6, sp
    call4 common_exception_handler

    // disable exceptions
    call0 disable_kernel_exceptions

    // restore the context that we saved
    call0 restore_full_interrupt_context

    // TODO: confirm PID

    // finish up by restoring a0-a2 and finally
    // return from the exception, a1 must be restored
    // last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a3, sp, TASK_REGS_AR(3)
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
    // spill the full context
    call0 save_full_interrupt_context

    // enable exceptions for C code
    call0 enable_kernel_exceptions

    // now call the common interrupt handler with
    // the task_regs_t
    mov a6, sp
    call4 common_interrupt_handler

    // disable exceptions
    call0 disable_kernel_exceptions

    // restore the context that we saved
    call0 restore_full_interrupt_context

    // TODO: confirm PID

    // finish up by restoring a0-a2 and finally
    // return from the exception, a1 must be restored
    // last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a3, sp, TASK_REGS_AR(3)
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
    // start by fixing the nextPC
    rsr.epc1 a0         // skip the syscall instruction
    addi a0, a0, 3

    // check if we need to emulate a loop
    // aka, PC == LEND && LCOUNT != 0
    rsr.lend a2
    bne a0, a2, .skipped_syscall
    rsr.lcount a2
    beqz a2, .skipped_syscall

    // we need to emulate it
    addi a2, a2, -1     // decrement LCOUNT
    wsr.lcount a2
    rsr.lbeg a0         // set the PC to LBEG

.skipped_syscall:
    // actually update the PC
    wsr.epc1 a0

    // TODO: fast path, that won't save everything

    j .slow_path

.fast_path:
    //-------------------------------------------------
    // fast path, check for IPC syscall and
    // small payload
    //-------------------------------------------------

    // TODO: do fast path handling

    // return from the fast path
    j .return_from_syscall

.slow_path:
    //-------------------------------------------------
    // slow path, we are going to call C code,
    // save everything
    //-------------------------------------------------

    // spill the full context
    call0 save_full_interrupt_context

    // enable exceptions for C code
    call0 enable_kernel_exceptions

    // now call the common interrupt handler with
    // the task_regs_t
    mov a6, sp
    call4 common_syscall_handler

    // disable exceptions
    call0 disable_kernel_exceptions

    // restore the context that we saved
    call0 restore_full_interrupt_context

.return_from_syscall:
    // TODO: confirm PID

    // finish up by restoring a0-a2 and finally
    // return from the exception, a1 must be restored
    // last since it is the actual stack pointer
    l32i a0, sp, TASK_REGS_AR(0)
    l32i a2, sp, TASK_REGS_AR(2)
    l32i a3, sp, TASK_REGS_AR(3)
    l32i a1, sp, TASK_REGS_AR(1)
    rfe
.size syscall_entry, . - syscall_entry