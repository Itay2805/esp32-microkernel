
/****************/
/* kernel entry */
/****************/

ENTRY(_start)

/*************************************/
/* memory ranges used for the kernel */
/*************************************/


/*
 * we use SRAM1 for the kernel because it is governed by a static MPU
 * the total size is 128K we will separate it half and half
 */
MEMORY {
    IRAM (RX)       : ORIGIN = 0x40080000, len = 128K
    DRAM (RW)       : ORIGIN = 0x3FFC0000, len = 128K
}

/**********************/
/* section definition */
/**********************/

SECTIONS {

    .text : {
        /* create the kernel header */
        LONG(0x20505041);    /* magic */
        LONG(SIZEOF(.text)); /* code size */
        LONG(SIZEOF(.data)); /* data size */
        LONG(SIZEOF(.bss));  /* bss size */
        LONG(_start);        /* entry pointer */

        /* now have the kernel code */
        . = ALIGN(16);
        *(.text .text.*)
        . = ALIGN(4);
    } > IRAM

    .data : {
        *(.rodata .rodata.*)
        *(.data .data.*)
        *(COMMON)
    } > DRAM

    .bss : {
        *(.bss .bss.*)
    } > DRAM
}
