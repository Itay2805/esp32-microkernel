#include "scheduler.h"

static task_t* m_current_task = NULL;

void scheduler_queue(task_t* task) {

}

void scheduler_next() {

}

task_t* get_current_task() {
    return m_current_task;
}
