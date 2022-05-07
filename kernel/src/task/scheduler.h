#pragma once

#include "task.h"

void init_scheduler();

/**
 * Get the currently running task
 */
task_t* get_current_task();
