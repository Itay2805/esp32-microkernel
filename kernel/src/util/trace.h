#pragma once

#include "printf.h"

#define TRACE(fmt, ...) printf("[*] " fmt "\n\r", ## __VA_ARGS__);
#define ERROR(fmt, ...) printf("[-] " fmt "\n\r", ## __VA_ARGS__);
#define WARN(fmt, ...) printf("[!] " fmt "\n\r", ## __VA_ARGS__);
#define DEBUG(fmt, ...) printf("[?] " fmt "\n\r", ## __VA_ARGS__);


