#include "dport.h"
#include "pid.h"
#include "arch/cpu.h"

#include <util/defs.h>

#include <stdint.h>
#include <stddef.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hardware registers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef union _DPORT_CACHE_CTRL {
    struct {
        uint32_t _reserved0 : 3;
        uint32_t cache_enable : 1;
        uint32_t cache_flush_ena : 1;
        uint32_t cache_flush_done : 1;
        uint32_t _reserved1 : 4;
        uint32_t single_iram_enable : 1;
        uint32_t dram_split : 1;
        uint32_t _reserved2 : 4;
        uint32_t dram_hl : 1;
        uint32_t _reserved3 : 15;
    };
    uint32_t packed;
} PACKED DPORT_CACHE_CTRL_REG;
STATIC_ASSERT(sizeof(DPORT_CACHE_CTRL_REG) == sizeof(uint32_t));

typedef union _DPORT_MMU_TABLE_REG {
    struct {
        uint32_t address : 4;
        uint32_t access_rights : 3;
        uint32_t _reserved : 25;
    };
    uint32_t packed;
} PACKED DPORT_MMU_TABLE_REG;
STATIC_ASSERT(sizeof(DPORT_MMU_TABLE_REG) == sizeof(uint32_t));

// System and memory registers
extern volatile uint32_t DPORT_PRO_BOOT_REMAP_CTRL;
extern volatile uint32_t DPORT_APP_BOOT_REMAP_CTRL;
extern volatile uint32_t DPORT_CACHE_MUX_MODE;

// Reset and clock registers

// Interrupt matrix registers
extern volatile uint32_t DPORT_INTR_FROM_CPU[4];
extern volatile uint32_t DPORT_PRO_INTR_STATUS[3];
extern volatile uint32_t DPORT_APP_INTR_STATUS[3];
extern volatile uint32_t DPORT_PRO_INT_MAP[69];
extern volatile uint32_t DPORT_APP_INT_MAP[69];

// DMA registers

// MPU/MMU registers
extern volatile DPORT_CACHE_CTRL_REG DPORT_PRO_CACHE_CTRL;
extern volatile DPORT_CACHE_CTRL_REG DPORT_APP_CACHE_CTRL;

extern volatile uint32_t DPORT_IMMU_PAGE_MODE;
extern volatile uint32_t DPORT_DMMU_PAGE_MODE;
extern volatile uint32_t DPORT_AHB_MPU_TABLE[2];
extern volatile uint32_t DPORT_AHBLITE_MPU_TABLE[MPU_LAST];
extern volatile DPORT_MMU_TABLE_REG DPORT_IMMU_TABLE[16];
extern volatile DPORT_MMU_TABLE_REG DPORT_DMMU_TABLE[16];

extern volatile uint32_t DPORT_PRO_VECBASE_CTRL_REG;
extern volatile uint32_t DPORT_PRO_VECBASE_SET_REG;
extern volatile uint32_t DPORT_APP_VECBASE_CTRL_REG;
extern volatile uint32_t DPORT_APP_VECBASE_SET_REG;

// APP_CPU controller registers

// Peripheral clock gating and reset registers

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------------------------------------
// Initialization
//----------------------------------------------------------------------------------------------------------------------

extern symbol_t vecbase;

void init_dport() {
    // set no remapping for both cpus
    DPORT_PRO_BOOT_REMAP_CTRL = 0;
    DPORT_APP_BOOT_REMAP_CTRL = 0;

    // disable the cache before we do anything
    // this will also set the iram special mode to
    // false and the virtual address mode to normal
    DPORT_PRO_CACHE_CTRL.packed = 0;
    DPORT_APP_CACHE_CTRL.packed = 0;

    // set the cache mode for:
    //  Pool 0 -> PRO CPU
    //  Pool 1 -> APP CPU
    DPORT_CACHE_MUX_MODE = 0;

    // flush the caches in case something
    // is already in there, do them both
    // at the same time
    DPORT_PRO_CACHE_CTRL.cache_flush_ena = 1;
    DPORT_APP_CACHE_CTRL.cache_flush_ena = 1;
    while (!DPORT_PRO_CACHE_CTRL.cache_flush_done);
    while (!DPORT_APP_CACHE_CTRL.cache_flush_done);

    // now enable the cache
    DPORT_PRO_CACHE_CTRL.cache_enable = 1;
    DPORT_APP_CACHE_CTRL.cache_enable = 1;

    // unmap all the interrupts by setting all of them to the default
    // value, which is an internal interrupt which is unusable
    for (int i = 0; i < ARRAY_LEN(DPORT_PRO_INT_MAP); i++) {
        DPORT_PRO_INT_MAP[i] = 16;
        DPORT_APP_INT_MAP[i] = 16;
    }

    // make sure there are no cross-core interrupts
    for (int i = 0; i < 4; i++) {
        DPORT_INTR_FROM_CPU[i] = 0;
    }

    // setup the vecbase in the dport and tell the cpu to use that,
    // this should prevent the user from being able to change the
    // vecbase on its own.
    ASSERT(((uint32_t)vecbase & ((1 << 10) - 1)) == 0);
    DPORT_PRO_VECBASE_SET_REG = (uint32_t)vecbase >> 10;
    DPORT_PRO_VECBASE_CTRL_REG |= 0b11;
    DPORT_APP_VECBASE_SET_REG = (uint32_t)vecbase >> 10;
    DPORT_APP_VECBASE_CTRL_REG |= 0b11;
}

//----------------------------------------------------------------------------------------------------------------------
// Interrupt matrix stuff
//----------------------------------------------------------------------------------------------------------------------

/**
 * All the edge-triggered interrupts
 */
#define PERIPHERALS_EDGE_TRIGGERED (BIT10 | BIT22 | BIT28 | BIT30)

/**
 * Free peripheral interrupts (both edge and level) that are
 * only priority level 1
 */
uint32_t m_free_peripheral_interrupt =
        BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT8 |
        BIT9 | BIT10 | BIT12 | BIT13 | BIT17 | BIT18;

err_t dport_map_interrupt(interrupt_source_t source, bool edge_triggered) {
    err_t err = NO_ERROR;

    // check that source is in a valid range
    CHECK(source >= 0);
    CHECK(source <= 68);

    // mask properly and make sure there are enough of these
    uint32_t free_peripheral_interrupt = m_free_peripheral_interrupt;
    if (edge_triggered) {
        free_peripheral_interrupt &= PERIPHERALS_EDGE_TRIGGERED;
    } else {
        free_peripheral_interrupt &= ~PERIPHERALS_EDGE_TRIGGERED;
    }
    CHECK_ERROR(free_peripheral_interrupt != 0, ERROR_OUT_OF_RESOURCES);

    // allocate the first available one
    uint32_t free = __builtin_ffs(free_peripheral_interrupt) - 1;
    m_free_peripheral_interrupt &= ~(1 << free);

    TRACE("Mapping %d -> %d", source, free);

    // map it properly
    DPORT_PRO_INT_MAP[source] = free;

cleanup:
    return err;
}

void dport_log_interrupt() {
    TRACE("Interrupts:");
    for (int i = 0; i < INTERRUPT_SOURCE_MAX; i++) {
        if (DPORT_PRO_INTR_STATUS[i / 32] & (1 << (i % 32))) {
            switch (i) {
                default: WARN("\tGot interrupt: #%d", i); break;
            }
        }
    }
}

//----------------------------------------------------------------------------------------------------------------------
// MMU/MPU stuff
//----------------------------------------------------------------------------------------------------------------------

STATIC_ASSERT(0x32C + MPU_UART * 4 == 0x32C);
STATIC_ASSERT(0x32C + MPU_SPI1 * 4 == 0x330);
STATIC_ASSERT(0x32C + MPU_SPI0 * 4 == 0x334);
STATIC_ASSERT(0x32C + MPU_GPIO * 4 == 0x338);
STATIC_ASSERT(0x32C + MPU_RTC * 4 == 0x348);
STATIC_ASSERT(0x32C + MPU_IO_MUX * 4 == 0x34c);
STATIC_ASSERT(0x32C + MPU_HINF * 4 == 0x354);
STATIC_ASSERT(0x32C + MPU_UHCI1 * 4 == 0x358);
STATIC_ASSERT(0x32C + MPU_I2S0 * 4 == 0x364);
STATIC_ASSERT(0x32C + MPU_UART1 * 4 == 0x368);
STATIC_ASSERT(0x32C + MPU_I2C_EXT0 * 4 == 0x374);
STATIC_ASSERT(0x32C + MPU_UHCI0 * 4 == 0x378);
STATIC_ASSERT(0x32C + MPU_SLCHOST * 4 == 0x37c);
STATIC_ASSERT(0x32C + MPU_RMT * 4 == 0x380);
STATIC_ASSERT(0x32C + MPU_PCNT * 4 == 0x384);
STATIC_ASSERT(0x32C + MPU_SLC * 4 == 0x388);
STATIC_ASSERT(0x32C + MPU_LEDC * 4 == 0x38c);
STATIC_ASSERT(0x32C + MPU_EFUSE * 4 == 0x390);
STATIC_ASSERT(0x32C + MPU_SPI_ENCRYPT * 4 == 0x394);
STATIC_ASSERT(0x32C + MPU_PWM0 * 4 == 0x39c);
STATIC_ASSERT(0x32C + MPU_TIMERGROUP * 4 == 0x3a0);
STATIC_ASSERT(0x32C + MPU_TIMERGROUP1 * 4 == 0x3a4);
STATIC_ASSERT(0x32C + MPU_SPI2 * 4 == 0x3a8);
STATIC_ASSERT(0x32C + MPU_SPI3 * 4 == 0x3ac);
STATIC_ASSERT(0x32C + MPU_APB_CTRL * 4 == 0x3b0);
STATIC_ASSERT(0x32C + MPU_I2C_EXT1 * 4 == 0x3b4);
STATIC_ASSERT(0x32C + MPU_SDIO_HOST * 4 == 0x3b8);
STATIC_ASSERT(0x32C + MPU_EMAC * 4 == 0x3bc);
STATIC_ASSERT(0x32C + MPU_PWM1 * 4 == 0x3c4);
STATIC_ASSERT(0x32C + MPU_I2S1 * 4 == 0x3c8);
STATIC_ASSERT(0x32C + MPU_UART2 * 4 == 0x3cc);
STATIC_ASSERT(0x32C + MPU_PWR * 4 == 0x3e4);

err_t init_mmu() {
    err_t err = NO_ERROR;

    // config both IMMU and DMMU with 8kb pages
    // also need to enable the first bit to enable the mmu
    DPORT_IMMU_PAGE_MODE = 0;
    DPORT_DMMU_PAGE_MODE = 0;

    // setup the vdso page, it is always mapped at the last page
    // of the usermode area, and is available to all the pages
    DPORT_IMMU_TABLE[15].address = 15;
    DPORT_IMMU_TABLE[15].access_rights = 1;

    // no DMA is allowed for now
    for (int i = 0; i < 2; i++) {
        DPORT_AHB_MPU_TABLE[i] = 0;
    }

cleanup:
    return err;
}

void mmu_activate(mmu_t* space) {
    ASSERT(space != NULL);
    per_cpu_context_t* context = get_cpu_context();

    // check if we have a binding for this space already
    int lru_pid = 0;
    for (int i = 0; i < PID_BINDING_COUNT; i++) {
        mmu_t* bound = context->pid_bindings[i].bound_space;
        if (bound == space) {
            // we found a binding for this space
            if (!pid_binding_is_primary(&context->pid_bindings[i])) {
                // not the current want, move to it
                pid_binding_rebind(&context->pid_bindings[i]);
            }
            return;
        }

        // choose the LRU bindings
        if (context->pid_bindings[i].primary_stamp < context->pid_bindings[lru_pid].primary_stamp) {
            lru_pid = i;
        }
    }

    // we need to bind a new space, use the one we found
    pid_binding_bind(&context->pid_bindings[lru_pid], space);
}

err_t mmu_map(mmu_t* mmu, mmu_space_type_t type, uint8_t virt, page_entry_t entry) {
    err_t err = NO_ERROR;
    int bit = (1 << virt);

    CHECK(virt < MAX_PAGE_COUNT);

    // map it
    mmu_space_t* space = type == MMU_SPACE_CODE ? &mmu->immu : &mmu->dmmu;
    space->entries[virt] = entry;

    // if the process is running, update the mmu itself
    if (entry.type == PAGE_MAPPED && pid_binding_is_primary(mmu->binding)) {
        volatile DPORT_MMU_TABLE_REG* table_reg = &DPORT_IMMU_TABLE[entry.phys];
        table_reg->address = virt;
        table_reg->access_rights = mmu->binding->pid;
    }

cleanup:
    return err;
}

void mmu_load(mmu_t* space) {
    int pid = space->binding->pid;

    // go over the mmu entries
    for (int virt = 0; virt < 16; virt++) {
        // set the iram
        if (space->immu.entries[virt].type == PAGE_MAPPED) {
            uint8_t phys = space->immu.entries[virt].phys;
            DPORT_IMMU_TABLE[phys].address = virt;
            DPORT_IMMU_TABLE[phys].access_rights = pid;
        }

        // set the dram
        if (space->dmmu.entries[virt].type == PAGE_MAPPED) {
            uint8_t phys = space->dmmu.entries[virt].phys;
            DPORT_DMMU_TABLE[phys].address = virt;
            DPORT_DMMU_TABLE[phys].access_rights = pid;
        }
    }

    // set the peripheral access for the pid
    FOR_EACH_BIT(space->mpu_peripheral, it) {
        DPORT_AHBLITE_MPU_TABLE[1 << it] = 1 << pid;
    }
}

void mmu_unload(mmu_t* space) {
    int pid = space->binding->pid;

    // go over the mmu entries
    // TODO: do we want to have a mapped check instead maybe?
    //       I am not sure if it would be faster than just
    //       reading the access rights instead...
    for (int i = 0; i < 16; i++) {
        // remove anything in dram that has this bit
        if (DPORT_IMMU_TABLE[i].access_rights == pid) {
            DPORT_IMMU_TABLE[i].access_rights = 0;
        }

        // remove anything in iram that has this bit
        if (DPORT_DMMU_TABLE[i].access_rights == pid) {
            DPORT_DMMU_TABLE[i].access_rights = 0;
        }
    }

    // remove the peripheral access for the pid
    FOR_EACH_BIT(space->mpu_peripheral, it) {
        DPORT_AHBLITE_MPU_TABLE[1 << it] &= ~(1 << pid);
    }
}
