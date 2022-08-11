#include <stdint.h>
#include <stddef.h>

#include "trace.h"
#include "rom.h"
#include "lfs.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper macros
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define _STR(x) #x
#define STR(x) _STR(x)

#define ASSERT(check) \
    if (!(check)) { \
           ERROR("Assert `%s` failed at %s (%s:%d)", #check, __FUNCTION__, __FILE__, __LINE__); \
           while(1); \
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Registers that we need for our init
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern volatile uint32_t TIMG0_Tx_WDTCONFIG0;
extern volatile uint32_t TIMG1_Tx_WDTCONFIG0;
extern volatile uint32_t RTC_CNTL_WDTCONFIG0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The kernel header
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* the header */
typedef struct kernel_header {
    uint32_t magic;
    int32_t code_size;
    int32_t data_size;
    int32_t vdso_size;
    uint32_t entry_point;
} kernel_header_t;

#define KERNEL_MAGIC 0x4c4e524b
#define KERNEL_CODE_BASE ((void*)0x400A0000)
#define KERNEL_DATA_BASE ((void*)0x3FFE0000)
#define KERNEL_VDSO_BASE ((void*)0x4009E000)

typedef void (*kernel_entry_func_t)();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LFS management
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A temp buffer used for storing the kernel data while we transition
 * from the loader (+ bootrom) to the kernel
 */
static void* m_temp_buffer = (void*) 0x3FFD0000;

int spi_flash_read(const struct lfs_config *c, lfs_block_t block, lfs_off_t off, void *buffer, lfs_size_t size) {
    ASSERT((off % 4) == 0);
    ASSERT((size % 4) == 0);
    ASSERT(block + 4 < c->block_count + 4);

    // we need to skip 4 blocks from the start
    uint32_t addr = (block + 4) * c->block_size + off;
    int err = esp_rom_spiflash_read(addr, buffer, (int32_t)size);
    return err == 0 ? LFS_ERR_OK : LFS_ERR_IO;
}

static struct lfs_config m_lfs_config = {
    .read = spi_flash_read,

    // TODO: dynamically figure this out
    //       choosen specifically for W25Q128FW
    .read_size = 4,             // our function can read at multiplies of 4
    .read_buffer = (char[256]){},
    .prog_size = 256,           // page size is 256 bytes, so use that
    .prog_buffer = (char[256]){},
    .block_size = 4096,         // the minimum erasable block is 16 pages (4kb)
    .block_count = 4096 - 4,    // first 3 blocks are reserved for the loader
    .block_cycles = 500,        // idk, this is what the example uses
    .cache_size = 256,          // use the prog size ig
    .lookahead_size = 16,       // use the same value as the example
    .lookahead_buffer = (char[16]){},
};

static lfs_t m_lfs = {0 };

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The loader itself
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Disable watchdogs so we are not
 * gonna die from them
 */
static void disable_watchdogs() {
    TIMG0_Tx_WDTCONFIG0 = 0;
    TIMG1_Tx_WDTCONFIG0 = 0;
    RTC_CNTL_WDTCONFIG0 = 0;
}

void _start() {
    disable_watchdogs();

    uint8_t b;
    while (uart_rx_one_char(&b) != 0) {}

    TRACE("Welcome from the loader!");

    TRACE("\tConfiguring flash");
    esp_rom_spiflash_attach(0, false);
    ASSERT(esp_rom_spiflash_config_param(
            0,
            16 * 0x100000,
            0x10000,
            0x1000,
            0x100,
            0xffff
    ) == 0);

    TRACE("\tMounting rootfs");
    ASSERT(lfs_mount(&m_lfs, &m_lfs_config) == 0);

    TRACE("Loading kernel");

    // open the kernel file
    lfs_file_t kernel_file;
    struct lfs_file_config kernel_file_config = {
        .buffer = (char[256]){}
    };
    ASSERT(lfs_file_opencfg(&m_lfs, &kernel_file, "/kernel", LFS_O_RDONLY, &kernel_file_config) == 0);

    // load the kernel header and verify it
    kernel_header_t kernel_header;
    lfs_file_read(&m_lfs, &kernel_file, &kernel_header, sizeof(kernel_header));
    ASSERT(kernel_header.magic == KERNEL_MAGIC);

    size_t code_offset = 0;
    size_t data_offset = code_offset + kernel_header.code_size;
    size_t vdso_offset = data_offset + kernel_header.data_size;

    // make sure the kernel is actually small enough
    ASSERT(kernel_header.magic == KERNEL_MAGIC);
    ASSERT(kernel_header.code_size + kernel_header.data_size <= 128 * 1024);
    ASSERT(kernel_header.code_size % 4 == 0);
    ASSERT(kernel_header.data_size % 4 == 0);
    ASSERT(kernel_header.vdso_size % 4 == 0);
    ASSERT((uintptr_t)KERNEL_CODE_BASE <= kernel_header.entry_point);
    ASSERT(kernel_header.entry_point < (uintptr_t)KERNEL_CODE_BASE + kernel_header.code_size);

    // make sure that we have a big enough temp buffer
    ASSERT(kernel_header.code_size <= UINT16_MAX);
    ASSERT(kernel_header.data_size <= UINT16_MAX);
    ASSERT(kernel_header.vdso_size <= UINT16_MAX);

    TRACE("\tLoading code %p (%d bytes)", KERNEL_CODE_BASE, kernel_header.code_size);
    ASSERT(lfs_file_seek(&m_lfs, &kernel_file, code_offset, LFS_SEEK_SET) == code_offset);
    ASSERT(lfs_file_read(&m_lfs, &kernel_file, m_temp_buffer, kernel_header.code_size) == kernel_header.code_size);
    xthal_memcpy(KERNEL_CODE_BASE, m_temp_buffer, kernel_header.code_size);

    TRACE("\tLoading vdso %p (%d bytes)", KERNEL_VDSO_BASE, kernel_header.vdso_size);
    ASSERT(lfs_file_seek(&m_lfs, &kernel_file, vdso_offset, LFS_SEEK_SET) == vdso_offset);
    ASSERT(lfs_file_read(&m_lfs, &kernel_file, m_temp_buffer, kernel_header.vdso_size) == kernel_header.vdso_size);
    xthal_memcpy(KERNEL_VDSO_BASE, m_temp_buffer, kernel_header.vdso_size);

    TRACE("\tLoading data %p (%d bytes)", KERNEL_DATA_BASE, kernel_header.data_size);
    ASSERT(lfs_file_seek(&m_lfs, &kernel_file, data_offset, LFS_SEEK_SET) == data_offset);
    ASSERT(lfs_file_read(&m_lfs, &kernel_file, m_temp_buffer, kernel_header.data_size) == kernel_header.data_size);
    xthal_memcpy(KERNEL_DATA_BASE, m_temp_buffer, kernel_header.data_size);

    // NOTE: from here we should be super careful about everything since we just overrode the data
    //       region of the bootrom, potentially including the stack itself

    // call the kernel
    asm (
        "jx %0"
        :
        : "r"(kernel_header.entry_point)
    );
    while(1);
}
