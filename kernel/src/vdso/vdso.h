#pragma once

#define VDSO __attribute__((section(".vdso.text")))

/**
 * Used as the task entry before actually jumping to the user
 *
 * @param entry [IN] The user entry
 */
VDSO void task_trampoline(void(*entry)());
