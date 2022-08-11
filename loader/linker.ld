
/****************/
/* loader entry */
/****************/

ENTRY(_start)

/*************************************/
/* memory ranges used for the loader */
/*************************************/

/*
 * the kernel uses SRAM1 for itself, so we are going to use
 * SRAM0 and SRAM2 so we won't override each other
 */
MEMORY {
    IRAM (RX)       : ORIGIN = 0x40080000, len = 128K
    DRAM (RW)       : ORIGIN = 0x3FFC0000, len = 64K
}

/*************************************/
/* Symbols provided by the bootrom   */
/*************************************/

/* ROM functions */
ets_printf = 0x40007d54;
esp_rom_spiflash_attach = 0x40062a6c;
esp_rom_spiflash_read = 0x40062ed8;
esp_rom_spiflash_config_param = 0x40063238;
uart_tx_one_char = 0x40009200;
uart_rx_one_char = 0x400092d0;
xthal_memcpy = 0x4000c0bc;
memcpy = 0x4000c2c8;
memset = 0x4000c44c;
memcmp = 0x4000c260;
strspn = 0x4000c648;
strcspn = 0x4000c558;
strchr = 0x4000c53c;
strcpy = 0x400013ac;
printf = ets_printf;
__umoddi3 = 0x4000d280;
__udivdi3 = 0x4000cff8;
__bswapsi2 = 0x40064ae0;
__popcountsi2 = 0x40002ed0;

/* hardware registers */
TIMG0 = 0x3FF5F000;
TIMG1 = 0x3FF60000;
RTC = 0x3FF48000;

TIMG0_Tx_WDTCONFIG0 = TIMG0 + 0x48;
TIMG1_Tx_WDTCONFIG0 = TIMG1 + 0x48;
RTC_CNTL_WDTCONFIG0 = RTC + 0x8c;

/*************************************/
/* the sections for the loader       */
/*************************************/

SECTIONS {

    .text : {
        . = ALIGN(16);
        _text = .;
        *(.text)
        *(.text*)
        _text_end = .;
    } > IRAM

    .data : {
        . = ALIGN(4);
        _data = .;
        *(.rodata)
        *(.rodata*)

        . = ALIGN(4);
        *(.data)
        *(.data*)

        . = ALIGN(4);
        _bss = .;
        *(.bss)
        *(.bss*)
        _data_end = .;
    } > DRAM

}
