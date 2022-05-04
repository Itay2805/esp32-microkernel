ENTRY(_start)

/*
 * The VDSO is going to live at the end of the SRAM0 and is only
 * going to have code, no variables at all
 */
MEMORY {
    IRAM (RX)       : ORIGIN = 0x4009E000, len = 8K
}

/**********************/
/* section definition */
/**********************/

SECTIONS {
    .text : {
        /* create the vdso header */
        LONG(0x4F534456);    /* magic */
        LONG(SIZEOF(.text)); /* code size */
        LONG(vecbase);       /* the vecbase for the kernel */

        /* now have the kernel code */
        . = ALIGN(16);
        *(.text .text.*)
        . = ALIGN(4);
    } > IRAM
}
