#pragma once

#include "printf.h"

#define TRACE(fmt, ...) printf("[*] " fmt "\n\r", ## __VA_ARGS__);
#define ERROR(fmt, ...) printf("[-] " fmt "\n\r", ## __VA_ARGS__);
#define WARN(fmt, ...) printf("[!] " fmt "\n\r", ## __VA_ARGS__);
#define DEBUG(fmt, ...) printf("[?] " fmt "\n\r", ## __VA_ARGS__);

#define ASSERT(check) \
    if (!(check)) { \
       ERROR("Assert `%s` failed at %s (%s:%d)", #check, __FUNCTION__, __FILE__, __LINE__); \
       while(1); \
    }
