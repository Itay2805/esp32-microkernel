
#include <drivers/dport.h>

#include <util/trace.h>
#include "arch/intrin.h"
#include "drivers/pid.h"
#include "mem/mem.h"

void kmain() {
    err_t err = NO_ERROR;
    TRACE("Hello from kernel!");

    // start with basic init
    init_dport();
    init_mmu();
    init_pid();

    CHECK_AND_RETHROW(init_mem());

    TRACE("We are done here");
cleanup:
    ASSERT(!IS_ERROR(err));
    while(1);
}
