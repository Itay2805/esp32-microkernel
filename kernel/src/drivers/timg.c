#include "timg.h"
#include "util/trace.h"
#include "util/except.h"
#include "dport.h"

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
} MMIO TIMG_CONFIG_REG;
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
} MMIO TIMG_REG;
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
} MMIO TIMG_WDTCONFIG_REG;
STATIC_ASSERT(sizeof(TIMG_WDTCONFIG_REG) == sizeof(uint32_t));

typedef union _TIMG_INT_REG {
    struct {
        uint32_t t0_int : 1;
        uint32_t t1_int : 1;
        uint32_t wdt_int : 1;
        uint32_t _reserved : 29;
    };
    uint32_t packed;
} MMIO TIMG_INT_REG;
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

static void wdt_unlock() {
    TIMG0_WDTWPROTECT = 0x050D83AA1;
}

static void wdt_lock() {
    TIMG0_WDTWPROTECT = 0xDEADBEEF;
}

__attribute__((noinline))
err_t init_wdt() {
    err_t err = NO_ERROR;

    // allocate an interrupt for the watchdog
    CHECK_AND_RETHROW(dport_map_interrupt(TG_WDT_LEVEL_INT, false));

    wdt_unlock();

    // for pro cpu
    TIMG_WDTCONFIG_REG wdtconfig = {
        // do it as long as it is needed
        .level_int_en = 1,

        // for the stage 1 raise an interrupt, and we
        // will clear it manually
        .stg0 = 1,

        // we are going to give a small timeout until
        // we reset the System if we have a problem
        .stg1 = 3,
    };
    TIMG0_WDTCONFIG = wdtconfig;

    // set the prescaler to 40000 * 12.5ns == 0.5ms, which means we have
    // two ticks per ms, so we just need to multiply the ms by 2
    TIMG0_WDTCONFIG1 = 40000 << 16;

    // 10 ms for the first clock
    TIMG0_WDTCONFIG2 = 10;

    // 10ms for the second clock
    TIMG0_WDTCONFIG3 = 10;

    // enable it
    TIMG0_WDTCONFIG.en = 1;

    wdt_lock();

    // enable watchdog timeout
    TIMG0_INT_ENA.wdt_int = 1;

    // clear it
    TIMG0_INT_CLR.wdt_int = 1;

cleanup:
    return err;
}

void wdt_enable() {
    wdt_unlock();
    TIMG0_WDTCONFIG.en = 1;
    wdt_lock();
}

void wdt_disable() {
    wdt_unlock();
    TIMG0_WDTCONFIG.en = 0;
    wdt_lock();
}

void wdt_feed() {
    wdt_unlock();
    TIMG0_WDTFEED = 1;
    wdt_lock();
}

bool wdt_handle() {
    // check if we care
    if (!TIMG0_INT_ST.wdt_int)
        return false;

    // feed the watchdog
    wdt_feed();

    // clear the interrupts
    TIMG0_INT_CLR.wdt_int = 1;

    return true;
}
