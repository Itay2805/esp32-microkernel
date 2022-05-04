#pragma once

#include <stdint.h>

/**
 * Initialize the dport for kernel runtime
 */
void init_dport();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MMU related code
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    // the binding for this space
    struct pid_binding* binding;

    // the amount of bindings that this
    // space is written to
    int binding_count;
} mmu_t;

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
