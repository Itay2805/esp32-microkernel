#pragma once

#include "dport.h"

#include <stdint.h>
#include <stdbool.h>

/**
 * The amount of free pid entries
 */
#define PID_BINDING_COUNT 6

/**
 * Represent a pid cache
 */
typedef struct pid_binding {
    // the last use timestamp
    uint64_t primary_stamp;

    // the currently bound address space
    mmu_t* bound_space;

    // the hardware pid for this
    uint8_t pid;
} pid_binding_t;

/**
 * Setup the PID controller
 *
 * This will also setup the vecbase and related stuff
 */
void init_pid();

/**
 * switch to the current pid
 */
void pid_switch(int delay);

/**
 * Checks if this pid binding is the currently bound one
 */
bool pid_binding_is_primary(pid_binding_t* binding);

/**
 * Rebind an already bound pid binding
 */
void pid_binding_rebind(pid_binding_t* binding);

/**
 * Bind a new space to the given binding
 */
void pid_binding_bind(pid_binding_t* binding, mmu_t* space);

/**
 * Unbind the space from the given binding
 */
void pid_binding_unbind(pid_binding_t* binding);
