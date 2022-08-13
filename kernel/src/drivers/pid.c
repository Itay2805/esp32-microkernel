#include "pid.h"
#include "arch/cpu.h"

#include <arch/intrin.h>

#include <util/trace.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hardware registers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern volatile uint32_t PIDCTRL_INTERRUPT_ENABLE;
extern volatile uint32_t PIDCTRL_INTERRUPT_ADDR[7];
extern volatile uint32_t PIDCTRL_PID_DELAY;
extern volatile uint32_t PIDCTRL_NMI_DELAY;
extern volatile uint32_t PIDCTRL_LEVEL;
extern volatile uint32_t PIDCTRL_FROM[7];
extern volatile uint32_t PIDCTRL_PID_NEW_REG;
extern volatile uint32_t PIDCTRL_PID_CONFIRM;
extern volatile uint32_t PIDCTRL_NMI_MASK_ENABLE;
extern volatile uint32_t PIDCTRL_NMI_MASK_DISABLE;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------------------------------------
// Initialization
//----------------------------------------------------------------------------------------------------------------------

extern symbol_t vecbase;

void init_pid() {
    // we are going to skip the kernel exception vector since we care about it less
    PIDCTRL_INTERRUPT_ADDR[0] = (uintptr_t)vecbase + 0x340; /* user exception handler */
    PIDCTRL_INTERRUPT_ADDR[1] = (uintptr_t)vecbase + 0x180; /* interrupt level 2 */
    PIDCTRL_INTERRUPT_ADDR[2] = (uintptr_t)vecbase + 0x1c0; /* interrupt level 3 */
    PIDCTRL_INTERRUPT_ADDR[3] = (uintptr_t)vecbase + 0x200; /* interrupt level 4 */
    PIDCTRL_INTERRUPT_ADDR[4] = (uintptr_t)vecbase + 0x240; /* interrupt level 5 */
    PIDCTRL_INTERRUPT_ADDR[5] = (uintptr_t)vecbase + 0x280; /* interrupt level 6 (debug) */
    PIDCTRL_INTERRUPT_ADDR[6] = (uintptr_t)vecbase + 0x2c0; /* interrupt level 7 (nmi) */

    // set the level and from to zero
    PIDCTRL_LEVEL = 0;
    for (int i = 0; i < ARRAY_LEN(PIDCTRL_FROM); i++) {
        PIDCTRL_FROM[i] = 0;
    }

    // set the pid interrupt tracking for all 7 levels
    PIDCTRL_INTERRUPT_ENABLE = 0b11111110;

    // set the delay, this was calculated exactly as needed
    PIDCTRL_PID_DELAY = 0;

    // setup the pids
    pid_binding_t* binding = get_cpu_context()->pid_bindings;
    for (int i = 0; i < PID_BINDING_COUNT; i++) {
        binding[i].pid = i + 2;
    }
}

__attribute__((noinline)) void pid_prepare() {
    // get the pid that we want to switch to
    int current_pid = get_cpu_context()->primary_binding->pid;

    // set it
    PIDCTRL_PID_NEW_REG = current_pid;
}

bool pid_binding_is_primary(pid_binding_t* binding) {
    return binding != NULL && get_cpu_context()->primary_binding == binding;
}

void pid_binding_rebind(pid_binding_t* binding) {
    per_cpu_context_t* context = get_cpu_context();

    // set the primary space and the binding stamp
    binding->primary_stamp = context->next_stamp++;
    context->primary_binding = binding;
}

void pid_binding_bind(pid_binding_t* binding, mmu_t* space) {
    per_cpu_context_t* context = get_cpu_context();
    mmu_t* unbound_space = binding->bound_space;

    // set the new space
    binding->bound_space = space;

    // remove the entries of the old state
    if (unbound_space != NULL) {
        mmu_unload(unbound_space);
    }

    // set the entries of the new state
    space->binding = binding;
    mmu_load(space);

    // set the primary space and the binding stamp
    binding->primary_stamp = context->next_stamp++;
    context->primary_binding = binding;
}

void pid_binding_unbind(pid_binding_t* binding) {
    // remove the entries for this space
    mmu_unload(binding->bound_space);
    binding->bound_space->binding = NULL;

    // set the unbound space
    binding->bound_space = NULL;
}
