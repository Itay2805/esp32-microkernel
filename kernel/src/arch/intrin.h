#pragma once

#include <util/defs.h>

#include <stdint.h>

//----------------------------------------------------------------------------------------------------------------------
// Special registers and access to them
//----------------------------------------------------------------------------------------------------------------------

#define __WSR(reg, value) \
    do { \
        asm volatile ("wsr %0, " STR(reg) :: "r"((uint32_t)value)); \
    } while (0)

#define __RSR(reg) \
    ({\
        uint32_t value; \
        asm volatile ("rsr %0, " STR(reg) : "=r"(value)); \
        value; \
    })

static inline void __rsync() {
    asm volatile ("rsync");
}

//----------------------------------------------------------------------------------------------------------------------
// Wrappers for special registers
//----------------------------------------------------------------------------------------------------------------------

typedef union ps {
    struct {
        uint32_t intlevel : 4;
        uint32_t excm : 1;
        uint32_t um : 1;
        uint32_t ring : 2;
        uint32_t owb : 4;
        uint32_t _reserved0 : 4;
        uint32_t callinc : 2;
        uint32_t woe : 1;
        uint32_t _reserved1 : 13;
    };
    uint32_t packed;
} PACKED ps_t;
STATIC_ASSERT(sizeof(ps_t) == sizeof(uint32_t));

static inline ps_t __read_ps() {
    return (ps_t) { .packed = __RSR(PS) };
}

static inline void __write_ps(ps_t ps) {
    __WSR(PS, ps.packed);
}

static inline uint32_t __ccount() {
    return __RSR(CCOUNT);
}
