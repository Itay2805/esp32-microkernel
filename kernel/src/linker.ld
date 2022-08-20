
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
    DUMMY (R)       : ORIGIN = 0x00000000, len = 128K
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
INCLUDE src/drivers/rtc_cntl.ld
INCLUDE src/drivers/timg.ld
INCLUDE src/drivers/uart.ld

/**********************/
/* section definition */
/**********************/

SECTIONS {

    .header : {
        /* create the kernel header */
        LONG(0x4c4e524b);           /* magic */
        LONG(SIZEOF(.text));        /* code size */
        LONG(SIZEOF(.data));        /* data size */
        LONG(SIZEOF(.vdso));        /* vdso size */
        LONG(_start);               /* entry pointer */
    } > DUMMY

    .text : {
        *(.text .text.*)
        . = ALIGN(4);
    } > IRAM

    .data : {
        *(.rodata .rodata.*)
        *(.data .data.*)
        . = ALIGN(4);
        _data_end = .;

        *(.bss .bss.*)
        *(COMMON)
        _bss_end = .;

        /* the heap starts right after the bss */
        . = ALIGN(16);
        _heap_start = .;
    } > DRAM

    .vdso : {
        *(.vdso .vdso.*)
    } > VDSO_IRAM

    /* calculate the heap size, which is the size left between code and data */
    _heap_size = 128K - SIZEOF(.text) - SIZEOF(.data);
    _heap_end = _heap_start + _heap_size;
}
