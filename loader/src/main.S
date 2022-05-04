
.extern loader_main

.global _start
.align 16
_start:
    // set the stack pointer to the end of SRAM 2
    // which should not be occupied by anything
    // at this point
    movi a1, 0x3FFD0000

    // jump to kernel
    movi a0, loader_main
    jx a0
