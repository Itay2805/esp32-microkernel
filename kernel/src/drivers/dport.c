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

extern volatile uint32_t DPORT_PRO_BOOT_REMAP_CTRL;
extern volatile uint32_t DPORT_APP_BOOT_REMAP_CTRL;
extern volatile uint32_t DPORT_CACHE_MUX_MODE;

extern volatile DPORT_MMU_TABLE_REG DPORT_IMMU_TABLE[16];
extern volatile DPORT_MMU_TABLE_REG DPORT_DMMU_TABLE[16];

extern volatile DPORT_CACHE_CTRL_REG DPORT_PRO_CACHE_CTRL;
extern volatile DPORT_CACHE_CTRL_REG DPORT_APP_CACHE_CTRL;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------------------------------------
// Initialization
//----------------------------------------------------------------------------------------------------------------------

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
}

//----------------------------------------------------------------------------------------------------------------------
// MMU stuff
//----------------------------------------------------------------------------------------------------------------------

void mmu_activate(mmu_t* space) {
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

void mmu_load(mmu_t* space) {
    // go over the mmu entries
    for (int i = 0; i < 16; i++) {
        // set the iram
        if (space->immu.mapped & (1 << i) && !space->immu.entries[i].psram) {
            DPORT_IMMU_TABLE[i].address = space->immu.entries[i].phys;
            DPORT_IMMU_TABLE[i].access_rights = space->binding->pid;
        }

        // set the dram
        if (space->dmmu.mapped & (1 << i) && !space->dmmu.entries[i].psram) {
            DPORT_DMMU_TABLE[i].address = space->dmmu.entries[i].phys;
            DPORT_DMMU_TABLE[i].access_rights = space->binding->pid;
        }
    }
}

void mmu_unload(mmu_t* space) {
    // go over the mmu entries
    for (int i = 0; i < 16; i++) {
        // remove anything in dram that has this bit
        if (DPORT_IMMU_TABLE[i].access_rights == space->binding->pid) {
            DPORT_IMMU_TABLE[i].access_rights = 0;
        }

        // remove anything in iram that has this bit
        if (DPORT_DMMU_TABLE[i].access_rights == space->binding->pid) {
            DPORT_DMMU_TABLE[i].access_rights = 0;
        }
    }
}
