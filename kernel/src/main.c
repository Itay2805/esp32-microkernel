
#include <drivers/dport.h>

#include <util/trace.h>
#include "arch/intrin.h"
#include "drivers/pid.h"

void kmain() {
    TRACE("Hello from kernel!");

    // start with basic init
    init_dport();
    init_pid();

    TRACE("We are done here");
    while(1);
}
