#pragma once

#include "task.h"

/**
 * Queues the given thread, so it will run
 */
void scheduler_queue(task_t* task);

/**
 * Parks the given thread, so it can wait for an event
 */
void scheduler_park(task_t* task);

/**
 * Make the scheduler select a new thread
 */
void scheduler_next();

/**
 * Get the current task
 */
task_t* get_current_task();
