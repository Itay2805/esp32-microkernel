#include "scheduler.h"
#include "arch/cpu.h"
#include "drivers/timg.h"
#include "syscall.h"

// little helper to deal with the global run queue
typedef struct task_queue {
    task_t* head;
    task_t* tail;
} task_queue_t;

static void task_queue_push_back(task_queue_t* q, task_t* thread) {
    thread->sched_link = NULL;
    if (q->tail != NULL) {
        q->tail->sched_link = thread;
    } else {
        q->head = thread;
    }
    q->tail = thread;
}

static task_t* task_queue_pop(task_queue_t* q) {
    task_t* task = q->head;
    if (task != NULL) {
        q->head = task->sched_link;
        if (q->head == NULL) {
            q->tail = NULL;
        }
    }
    return task;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Global run queue
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define RUN_QUEUE_LEN 256

// The global run queue
static task_queue_t m_global_run_queue;
static int32_t m_global_run_queue_size;

// spinlock to protect the scheduler internal stuff
//static irq_spinlock_t m_scheduler_lock = INIT_IRQ_SPINLOCK();

static void global_run_queue_put(task_t* task) {
    task_queue_push_back(&m_global_run_queue, task);
    m_global_run_queue_size++;
}

static task_t* global_run_queue_get() {
    if (m_global_run_queue_size == 0) {
        return NULL;
    }
    m_global_run_queue_size--;
    task_t* task = task_queue_pop(&m_global_run_queue);
    return task;
}

static void lock_scheduler() {
//    irq_spinlock_lock(&m_scheduler_lock);
}

static void unlock_scheduler() {
//    irq_spinlock_unlock(&m_scheduler_lock);
}

static void wake_cpu() {
    // TODO: this
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wake a thread
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void scheduler_ready_task(task_t* task) {
    task->sched_link = NULL;

    scheduler_preempt_disable();

    ASSERT((get_task_status(task) & ~TASK_SUSPEND) == TASK_STATUS_WAITING);

    // Mark as runnable
    cas_task_state(task, TASK_STATUS_WAITING, TASK_STATUS_RUNNABLE);

    // Put in the run queue
    lock_scheduler();
    global_run_queue_put(task);
    unlock_scheduler();

    // in case someone can steal
    wake_cpu();

    scheduler_preempt_enable();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Preemption
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void scheduler_preempt_disable(void) {
    if (get_cpu_context()->preempt_disable_depth++ == 0) {
        // TODO: enable no preemption
    }
}

void scheduler_preempt_enable(void) {
    if (++get_cpu_context()->preempt_disable_depth == 0) {
        // TODO: disable no preemption
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Actual scheduling
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------------------------------------
// Actually running a thread
//----------------------------------------------------------------------------------------------------------------------

static void scheduler_set_deadline() {
    wdt_feed();
    wdt_enable();
}

static void scheduler_cancel_deadline() {
    wdt_disable();
}

/**
 * Execute the thread on the current cpu
 *
 * @param ctx               [IN] The context of the scheduler interrupt
 * @param thread            [IN] The thread to run
 */
static void execute(task_regs_t* ctx, task_t* task) {
    // set the current thread
    get_cpu_context()->current_task = task;

    // get ready to run it
    cas_task_state(task, TASK_STATUS_RUNNABLE, TASK_STATUS_RUNNING);

    // set a new timeslice of 10 milliseconds
    scheduler_set_deadline();

    // set the gprs context
    restore_task_context(task, ctx);
}

static void save_current_task(task_regs_t* ctx, bool park) {
    per_cpu_context_t* pctx = get_cpu_context();

    ASSERT(pctx->current_task != NULL);
    task_t* current_task = pctx->current_task;
    pctx->current_task = NULL;

    // save the state and set the thread to runnable
    save_task_context(current_task, ctx);

    // put the thread back
    if (!park) {
        // set the thread to be runnable
        cas_task_state(current_task, TASK_STATUS_RUNNING, TASK_STATUS_RUNNABLE);

        // put in the local run queue
        global_run_queue_put(current_task);
    } else {
        cas_task_state(current_task, TASK_STATUS_RUNNING, TASK_STATUS_WAITING);
    }
}

//----------------------------------------------------------------------------------------------------------------------
// Scheduler itself
//----------------------------------------------------------------------------------------------------------------------

static void cpu_put_idle() {
}

static void cpu_wake_idle() {
}

static task_t* find_runnable() {
    task_t* task = NULL;

    while (true) {
        // get from the global run queue
        lock_scheduler();
        task = global_run_queue_get();
        unlock_scheduler();
        if (task != NULL) {
            return task;
        }

        //
        // We have nothing to do
        //

        lock_scheduler();
        if (m_global_run_queue_size != 0) {
            task = global_run_queue_get();
            unlock_scheduler();
            return task;
        }

        // we are now idle
        cpu_put_idle();

        unlock_scheduler();

        // TODO: spinning

        // we have nothing to do, so put the cpu into
        // a sleeping state until an interrupt or something
        // else happens. we will lower the state
        TRACE("NOTHING TO RUN");
        asm volatile ("WAITI 0");

        lock_scheduler();
        cpu_wake_idle();
        unlock_scheduler();

    }
}

static void schedule(task_regs_t* ctx) {
    // will block until a thread is ready, essentially an idle loop,
    // this must return something eventually.
    task_t* thread = find_runnable();

    // actually run the new thread
    execute(ctx, thread);
}

//----------------------------------------------------------------------------------------------------------------------
// Scheduler callbacks
//----------------------------------------------------------------------------------------------------------------------

void scheduler_on_schedule(task_regs_t* regs) {
    // save the current thread, don't park it
    save_current_task(regs, false);

    // now schedule a new thread
    schedule(regs);
}

void scheduler_on_park(task_regs_t* regs) {
    // save the current thread, park it
    save_current_task(regs, true);

    // check if we need to call a callback before we schedule
    per_cpu_context_t* pctx = get_cpu_context();
    if (pctx->park_callback != NULL) {
        pctx->park_callback(pctx->park_arg);
        pctx->park_callback = NULL;
        pctx->park_arg = NULL;
    }

    // cancel the deadline of the current thread, as it is parked
    scheduler_cancel_deadline();

    // schedule a new thread
    schedule(regs);
}

void scheduler_on_drop(task_regs_t* regs) {
    per_cpu_context_t* pctx = get_cpu_context();

    task_t* current_task = pctx->current_task;
    pctx->current_task = NULL;

    if (current_task != NULL) {
        // change the status to dead
        cas_task_state(current_task, TASK_STATUS_RUNNING, TASK_STATUS_DEAD);

        // release the reference that the scheduler has
        release_task(current_task);
    }

    // cancel the deadline of the current thread, as it is dead
    scheduler_cancel_deadline();

    schedule(regs);
}

//----------------------------------------------------------------------------------------------------------------------
// Interrupts to call the scheduler
//----------------------------------------------------------------------------------------------------------------------

void scheduler_yield() {
    // don't preempt if we can't preempt
    if (get_cpu_context()->preempt_disable_depth > 0) {
        return;
    }
    syscall0(SYSCALL_SCHED_YIELD);
}

void scheduler_park(void(*callback)(void* arg), void* arg) {
    get_cpu_context()->park_callback = callback;
    get_cpu_context()->park_arg = arg;
    syscall0(SYSCALL_SCHED_PARK);
}

void scheduler_drop_current() {
    syscall0(SYSCALL_SCHED_DROP);
}

task_t* get_current_task() {
    return get_cpu_context()->current_task;
}
