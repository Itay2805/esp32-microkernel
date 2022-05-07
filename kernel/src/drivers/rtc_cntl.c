#include "rtc_cntl.h"
#include "util/trace.h"

#include <util/defs.h>

#include <stdint.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hardware registers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef union _RTC_CNTL_SLP_TIMER1_REG {
    struct {
        uint32_t slp_val_hi : 16;
        uint32_t main_timer_alarm_en : 1;
        uint32_t _reserved : 15;
    };
    uint32_t packed;
} PACKED RTC_CNTL_SLP_TIMER1_REG;
STATIC_ASSERT(sizeof(RTC_CNTL_SLP_TIMER1_REG) == sizeof(uint32_t));

typedef union _RTC_CNTL_INT_REG {
    struct {
        uint32_t slp_wakeup_int : 1;
        uint32_t slp_reject_int : 1;
        uint32_t sdio_idle_int : 1;
        uint32_t wdt_int : 1;
        uint32_t time_valid_int : 1;
        uint32_t ulp_cp_int : 1;
        uint32_t touch_int : 1;
        uint32_t brown_out_int : 1;
        uint32_t main_timer_int : 1;
        uint32_t _reserved : 23;
    };
    uint32_t packed;
} PACKED RTC_CNTL_INT_REG;
STATIC_ASSERT(sizeof(RTC_CNTL_INT_REG) == sizeof(uint32_t));

typedef union _RTC_CNTL_TIME_UPDATE_REG {
    struct {
        uint32_t _reserved : 30;
        uint32_t time_valid : 1;
        uint32_t time_update : 1;
    };
    uint32_t packed;
} PACKED RTC_CNTL_TIME_UPDATE_REG;
STATIC_ASSERT(sizeof(RTC_CNTL_TIME_UPDATE_REG) == sizeof(uint32_t));

typedef union _RTC_CNTL_WDTCONFIG0_REG {
    struct {
        uint32_t _reserved0 : 7;
        uint32_t pause_in_slp : 1;
        uint32_t appcpu_reset_en : 1;
        uint32_t procpu_reset_en : 1;
        uint32_t fashboot_mod_en : 1;
        uint32_t sys_reset_length : 3;
        uint32_t cpu_reset_length : 3;
        uint32_t _reserved1 : 1;
        uint32_t _reserved2 : 1;
        uint32_t stg3 : 3;
        uint32_t stg2 : 3;
        uint32_t stg1 : 3;
        uint32_t stg0 : 3;
        uint32_t en : 1;
    };
    uint32_t packed;
} PACKED RTC_CNTL_WDTCONFIG0_REG;
STATIC_ASSERT(sizeof(RTC_CNTL_WDTCONFIG0_REG) == sizeof(uint32_t));

extern volatile uint32_t RTC_CNTL_TIMER0;
extern volatile RTC_CNTL_SLP_TIMER1_REG RTC_CNTL_SLP_TIMER1;
extern volatile RTC_CNTL_TIME_UPDATE_REG RTC_CNTL_TIME_UPDATE;
extern volatile uint32_t RTC_CNTL_TIME0;
extern volatile uint32_t RTC_CNTL_TIME1;
extern volatile RTC_CNTL_INT_REG RTC_CNTL_INT_ENA;
extern volatile RTC_CNTL_INT_REG RTC_CNTL_INT_RAW;
extern volatile RTC_CNTL_INT_REG RTC_CNTL_INT_ST;
extern volatile RTC_CNTL_INT_REG RTC_CNTL_INT_CLR;
extern volatile uint32_t RTC_CNTL_STORE0[4];
extern volatile RTC_CNTL_WDTCONFIG0_REG RTC_CNTL_WDTCONFIG0;
extern volatile uint32_t RTC_CNTL_WDTCONFIG[4];
extern volatile uint32_t RTC_CNTL_WDTFEED;
extern volatile uint32_t RTC_CNTL_WDTWPROTECT;
extern volatile uint32_t RTC_CNTL_STORE1[4];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
