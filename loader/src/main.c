#include <stdint.h>
#include <stddef.h>

#include "trace.h"
#include "rom.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper macros
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define _STR(x) #x
#define STR(x) _STR(x)

#define ASSERT(...) \
    if (!(__VA_ARGS__)) { \
        ERROR("Assertion failed: %s, file %s, line %d", #__VA_ARGS__, __FILE__, __LINE__); \
        while(1); \
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Registers that we need for our init
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern volatile uint32_t TIMG0_Tx_WDTCONFIG0;
extern volatile uint32_t TIMG1_Tx_WDTCONFIG0;
extern volatile uint32_t RTC_CNTL_WDTCONFIG0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The loader itself
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* the header */
typedef struct kernel_header {
    uint32_t magic;
    int32_t code_size;
    int32_t data_size;
    uint32_t entry_point;
} kernel_header_t;

#define KERNEL_MAGIC 0x524E4C4B
#define KERNEL_CODE_BASE ((void*)0x400A0000)
#define KERNEL_DATA_BASE ((void*)0x3FFE0000)

typedef struct vdso_header {
    uint32_t magic;
    int32_t code_size;
    uint32_t vecbase;
} vdso_header_t;

#define VDSO_MAGIC 0x4F534456
#define VDSO_CODE_BASE ((void*)0x4009E000)

/**
 * Small wrapper to read and abort on error
 */
static void spiflash_read(uint32_t src_addr, void* dest, int32_t len) {
    ASSERT(len % 4 == 0);
    int spiflash_read_status = esp_rom_spiflash_read(src_addr, dest, len);
    ASSERT(spiflash_read_status == 0);
}

typedef void (*kernel_entry_func_t)();

/**
 * Actually load the kernel, also does verifications that everything looks fine
 */
static void load_kernel() {
    // load the kernel kernel_header
    kernel_header_t kernel_header = {0 };
    spiflash_read(0x2000, &kernel_header, sizeof(kernel_header));
    size_t vdso_header_offset = kernel_header.code_size + kernel_header.data_size;

    // make sure the kernel is actually small enough
    ASSERT(kernel_header.magic == KERNEL_MAGIC);
    ASSERT(kernel_header.code_size + kernel_header.data_size <= 128 * 1024);
    ASSERT(kernel_header.code_size % 4 == 0);
    ASSERT(kernel_header.data_size % 4 == 0);
    ASSERT((uintptr_t)KERNEL_CODE_BASE <= kernel_header.entry_point);
    ASSERT(kernel_header.entry_point < (uintptr_t)KERNEL_CODE_BASE + kernel_header.code_size);

    // load the vdso header
    vdso_header_t vdso_header = {};
    spiflash_read(0x2000 + vdso_header_offset, &vdso_header, sizeof(vdso_header));

    // make sure the vdso is fine
    ASSERT(vdso_header.magic == VDSO_MAGIC);
    ASSERT(vdso_header.code_size % 4 == 0);
    ASSERT(vdso_header.code_size <= 8 * 1024);
    ASSERT((uintptr_t)VDSO_CODE_BASE <= vdso_header.vecbase);
    ASSERT(vdso_header.vecbase < (uintptr_t)VDSO_CODE_BASE + vdso_header.code_size);

    // load the code and data to their places
    TRACE("\tLoading code (%d bytes)", kernel_header.code_size);
    spiflash_read(0x2000, KERNEL_CODE_BASE, kernel_header.code_size);
    TRACE("\tLoading data (%d bytes)", kernel_header.data_size);
    spiflash_read(0x2000 + kernel_header.code_size, KERNEL_DATA_BASE, kernel_header.data_size);
    TRACE("\tLoading vdso (%d bytes)", vdso_header.code_size);
    spiflash_read(0x2000 + vdso_header_offset, VDSO_CODE_BASE, vdso_header.code_size);

    // call the kernel
    kernel_entry_func_t entry = (kernel_entry_func_t)(void*)(uintptr_t)kernel_header.entry_point;
    TRACE("Calling kernel at %p", entry);
    entry();

    ASSERT(!"Kernel returned?!");
}


/**
 * Disable watchdogs so we are not
 * gonna die from them
 */
static void disable_watchdogs() {
    TIMG0_Tx_WDTCONFIG0 = 0;
    TIMG1_Tx_WDTCONFIG0 = 0;
    RTC_CNTL_WDTCONFIG0 = 0;
}

void loader_main() {
    disable_watchdogs();

    uint8_t b;
    while (uart_rx_one_char(&b) != 0) {}

    TRACE("Welcome from the loader!");

    load_kernel();
}
