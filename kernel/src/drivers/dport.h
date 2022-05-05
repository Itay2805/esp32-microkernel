#pragma once

#include <util/defs.h>

#include <stdint.h>

/**
 * Initialize the dport for kernel runtime
 */
void init_dport();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MMU/MPU abstraction
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum mpu_peripheral {
    MPU_UART = 0,
    MPU_SPI1 = 1,
    MPU_SPI0 = 2,
    MPU_GPIO = 3,
    /* MPU_ = 4, */
    /* MPU_ = 5, */
    /* MPU_ = 6, */
    MPU_RTC = 7,
    MPU_IO_MUX = 8,
    /* MPU_ = 9, */
    MPU_HINF = 10,
    MPU_UHCI1 = 11,
    /* MPU_ = 12, */
    /* MPU_ = 13, */
    MPU_I2S0 = 14,
    MPU_UART1 = 15,
    /* MPU_ = 16, */
    /* MPU_ = 17, */
    MPU_I2C_EXT0 = 18,
    MPU_UHCI0 = 19,
    MPU_SLCHOST = 20,
    MPU_RMT = 21,
    MPU_PCNT = 22,
    MPU_SLC = 23,
    MPU_LEDC = 24,
    MPU_EFUSE = 25,
    MPU_SPI_ENCRYPT = 26,
    /* MPU_ = 27, */
    MPU_PWM0 = 28,
    MPU_TIMERGROUP = 29,
    MPU_TIMERGROUP1 = 30,
    MPU_SPI2 = 31,
    MPU_SPI3 = 32,
    MPU_APB_CTRL = 33,
    MPU_I2C_EXT1 = 34,
    MPU_SDIO_HOST = 35,
    MPU_EMAC = 36,
    /* MPU_ = 37; */
    MPU_PWM1 = 38,
    MPU_I2S1 = 39,
    MPU_UART2 = 40,
    /* MPU_ = 41; */
    /* MPU_ = 42; */
    /* MPU_ = 43; */
    /* MPU_ = 44; */
    /* MPU_ = 45; */
    MPU_PWR = 46,
    MPU_LAST,
} mpu_peripheral_t;

/**
 * Forward declare
 */
struct pid_binding;

/**
 * Each page entry for tracking mapped pages
 */
typedef struct mmu_space_entry {
    // the physucal page of this, either on
    // psram or in sram
    uint8_t phys : 7;

    // is this page swapped out
    uint8_t psram : 1;
} mmu_space_entry_t;

/**
 * a single address space, either code or data
 */
typedef struct mmu_space {
    // virtual->physical
    mmu_space_entry_t entries[16];

    // which immu pages are mapped
    uint16_t mapped;
} mmu_space_t;

/**
 * The mmu context
 */
typedef struct mmu {
    // iram area
    mmu_space_t immu;

    // dram area
    mmu_space_t dmmu;

    // allows to control if we have
    // access to the given device's mmio
    uint64_t mpu_peripheral;

    // the binding for this space
    struct pid_binding* binding;
} mmu_t;

/**
 * Initialize MMU stuff
 */
void init_mmu();

/**
 * Activate the given MMU range
 */
void mmu_activate(mmu_t* space);

/**
 * Load the MMU entries
 */
void mmu_load(mmu_t* space);

/**
 * Unload MMU entries for the bound pid
 */
void mmu_unload(mmu_t* space);
