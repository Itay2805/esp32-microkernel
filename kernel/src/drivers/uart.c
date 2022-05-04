#include "uart.h"

#include <util/defs.h>

#include <stdint.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hardware registers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef union _UART_STATUS_REG {
    struct {
        uint32_t rxfifo_cnt : 8;
        uint32_t st_urx_out : 4;
        uint32_t _reserved0 : 1;
        uint32_t dsrn : 1;
        uint32_t ctsn : 1;
        uint32_t rxd : 1;
        uint32_t txfifo_cnt : 8;
        uint32_t st_utx_out : 4;
        uint32_t _reserved1 : 1;
        uint32_t dtrn : 1;
        uint32_t rtsn : 1;
        uint32_t txd : 1;
    };
    uint32_t packed;
} PACKED UART_STATUS_REG;
STATIC_ASSERT(sizeof(UART_STATUS_REG) == sizeof(uint32_t));

extern volatile uint32_t UART0_FIFO;
extern volatile UART_STATUS_REG UART0_STATUS;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void uart_write_char(char c) {
    // TODO: some delay

    // wait until the tx fifo has space
    while (UART0_STATUS.txfifo_cnt >= 128);
    UART0_FIFO = (uint32_t)c;
}

// TODO: init the uart tx size as we want it
