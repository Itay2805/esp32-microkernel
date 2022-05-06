
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
    IRAM (RX)       : ORIGIN = 0x400A0000, len = 128K
    DRAM (RW)       : ORIGIN = 0x3FFE0000, len = 128K
    VDSO_IRAM (RX)  : ORIGIN = 0x4009E000, len = 8K
}

/**********************************/
/* symbols for system peripherals */
/**********************************/

/* builtin stuff */
INCLUDE syms/bootrom.ld
INCLUDE syms/io.ld

/* drivers */
INCLUDE src/drivers/dport.ld
INCLUDE src/drivers/pid.ld
INCLUDE src/drivers/uart.ld

/**
 * The vdso is loaded to this address by the loader
 */
g_vdso_header = 0x4009E000;

/**********************/
/* section definition */
/**********************/

SECTIONS {

    .text : {
        /* create the kernel header */
        LONG(0x524E4C4B);    /* magic */
        LONG(SIZEOF(.text)); /* code size */
        LONG(SIZEOF(.data)); /* data size */
        LONG(SIZEOF(.vdso)); /* vdso size */
        LONG(_start);        /* entry pointer */

        /* now have the kernel code */
        . = ALIGN(16);
        *(.text .text.*)
        . = ALIGN(4);
    } > IRAM

    .data : {
        *(.rodata .rodata.*)
        *(.data .data.*)
        *(.bss .bss.*)
        *(COMMON)

        /* the heap starts right after the data */
        . = ALIGN(16);
        _heap_start = .;
    } > DRAM

    .vdso : {
        *(.vdso .vdso.*)
    } > VDSO_IRAM

    /* calculate the heap size, which is the size left between code and data */
    _heap_size = 128K - SIZEOF(.text) - SIZEOF(.data);
}
