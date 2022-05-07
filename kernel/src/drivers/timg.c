#include "timg.h"
#include "util/trace.h"

#include <util/defs.h>

#include <stdint.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hardware registers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef union _TIMG_CONFIG_REG {
    struct {
        uint32_t _reserved0 : 10;
        uint32_t alarm_en : 1;
        uint32_t level_int_en : 1;
        uint32_t edge_int_en : 1;
        uint32_t divider : 16;
        uint32_t autoreload : 1;
        uint32_t increase : 1;
        uint32_t en : 1;
    };
    uint32_t packed;
} PACKED TIMG_CONFIG_REG;
STATIC_ASSERT(sizeof(TIMG_CONFIG_REG) == sizeof(uint32_t));

typedef struct _TIMG_REG {
    TIMG_CONFIG_REG config;
    uint32_t lo;
    uint32_t hi;
    uint32_t update;
    uint32_t alarmlo;
    uint32_t alarmhi;
    uint32_t loadlo;
    uint32_t loadhi;
    uint32_t load;
} PACKED TIMG_REG;
STATIC_ASSERT(sizeof(TIMG_REG) == 0x24);

typedef union _TIMG_WDTCONFIG_REG {
    struct {
        uint32_t _reserved : 14;
        uint32_t flashboot_mod_en : 1;
        uint32_t sys_reset_length : 3;
        uint32_t cpu_reset_length : 3;
        uint32_t level_int_en : 1;
        uint32_t edge_int_en : 1;
        uint32_t stg3 : 2;
        uint32_t stg2 : 2;
        uint32_t stg1 : 2;
        uint32_t stg0 : 2;
        uint32_t en : 1;
    };
    uint32_t packed;
} PACKED TIMG_WDTCONFIG_REG;
STATIC_ASSERT(sizeof(TIMG_WDTCONFIG_REG) == sizeof(uint32_t));

typedef union _TIMG_INT_REG {
    struct {
        uint32_t t0_int : 1;
        uint32_t t1_int : 1;
        uint32_t wdt_int : 1;
        uint32_t _reserved : 29;
    };
    uint32_t packed;
} PACKED TIMG_INT_REG;
STATIC_ASSERT(sizeof(TIMG_INT_REG) == sizeof(uint32_t));

/* Timer group 0 */
extern volatile TIMG_REG TIMG0[2];
extern volatile TIMG_WDTCONFIG_REG TIMG0_WDTCONFIG;
extern volatile uint32_t TIMG0_WDTCONFIG1;
extern volatile uint32_t TIMG0_WDTCONFIG2;
extern volatile uint32_t TIMG0_WDTCONFIG3;
extern volatile uint32_t TIMG0_WDTCONFIG4;
extern volatile uint32_t TIMG0_WDTCONFIG5;
extern volatile uint32_t TIMG0_WDTFEED;
extern volatile uint32_t TIMG0_WDTWPROTECT;
extern volatile TIMG_INT_REG TIMG0_INT_ENA;
extern volatile TIMG_INT_REG TIMG0_INT_RAW;
extern volatile TIMG_INT_REG TIMG0_INT_ST;
extern volatile TIMG_INT_REG TIMG0_INT_CLR;

/* Timer group 1 */
// TODO: if needed

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * The amount of ticks per ms assuming the
 * default 32khz clock
 */
#define TICKS_PER_MS 32

void init_wdt() {
    // for pro cpu
    TIMG0_WDTCONFIG = (TIMG_WDTCONFIG_REG) {
        // do it as long as it is needed
        .level_int_en = 1,

        // for the stage 1 raise an interrupt, and we
        // will clear it manually
        .stg0 = 1,

        // we are going to give a small timeout until
        // we reset the CPU if we have a problem
        .stg1 = 2,
    };

    // 10 ms for the first clock
    TIMG0_WDTCONFIG2 = 1; //TICKS_PER_MS * 1000;

    // 1ms for the second clock
    TIMG0_WDTCONFIG3 = 1; //TICKS_PER_MS * 1;

    // protect the counter
    TIMG0_WDTWPROTECT = 0xDEADBEEF;

    // enable watchdog timeout
    TIMG0_INT_ENA.wdt_int = 1;

    // clear it
    TIMG0_INT_CLR.wdt_int = 1;

    // enable it
    TIMG0_WDTCONFIG.en = 1;
}

static void wdt_feed() {
    // unprotected it
    TIMG0_WDTWPROTECT = 0x050D83AA1;

    // touch it
    TIMG0_WDTFEED = 1;

    // protect it again
    TIMG0_WDTWPROTECT = 0xDEADBEEF;
}

void wdt_handle() {
    // check if we care
    if (!TIMG0_INT_ST.wdt_int)
        return;

    // feed the watchdog
    wdt_feed();

    // clear the interrupts
    TIMG0_INT_CLR.wdt_int = 1;

    TRACE("Got WatchDog timeout!");

    // TODO: call the scheduler
}
