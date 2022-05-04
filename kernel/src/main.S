
.section .text

.extern kmain

.global _start
.align 16
_start:
    // reset the windowbase and windowstart for function calls
    movi a1, 1
    movi a0, 0
    wsr a1, windowstart
    wsr a0, windowbase
    rsync

    // clear loop count
    wsr a0, lcount

    // jump to kernel
    movi a0, kmain
    jx a0
