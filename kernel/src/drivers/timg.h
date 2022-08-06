#pragma once

#include "util/except.h"

#include <stdbool.h>

/**
 * Initialize the watchdog and starting it
 */
err_t init_wdt();

/**
 * Enable watchdog
 */
void wdt_enable();

/**
 * Disable watchdog
 */
void wdt_disable();

/**
 * Feed watchdog
 */
void wdt_feed();

/**
 * Handle a watchdog interrupt
 */
bool wdt_handle();
