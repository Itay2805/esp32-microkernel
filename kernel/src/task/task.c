#include "task.h"
#include "mem/umem.h"

#include <util/string.h>

#include <stddef.h>

static pid_t m_pid = 0;

task_t* create_task() {
    // allocate the memory
    task_t* task = malloc(sizeof(task_t));
    if (task == NULL) {
        return NULL;
    }

    // zero it out
    memset(task, 0, sizeof(task_t));

    // initialize the uctx
    task->pid = m_pid++;

    // allocate the uctx
    task->ucontext = umem_alloc_data_page();
    memset(task->ucontext, 0, sizeof(task_ucontext_t));

    // TODO: initialize the uctx

    return task;
}
