#pragma once

#include <stddef.h>
#include <stdarg.h>

#include "rom.h"

#define TRACE(fmt, ...) ets_printf("[*] " fmt "\n\r", ## __VA_ARGS__);
#define ERROR(fmt, ...) ets_printf("[-] " fmt "\n\r", ## __VA_ARGS__);
#define WARN(fmt, ...) ets_printf("[!] " fmt "\n\r", ## __VA_ARGS__);
#define DEBUG(fmt, ...) ets_printf("[?] " fmt "\n\r", ## __VA_ARGS__);

/**
 * Write a string to the serial output
 */
void trace_string(const char* str);

/**
 * Trace a buffer as a pretty hexdump
 */
void trace_hex(const void* data, size_t size);
