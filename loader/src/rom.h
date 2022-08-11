#pragma once

#include <stdint.h>
#include <stdbool.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ROM functions that we are going to use for ease of use
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// from xthal
void* xthal_memcpy(void *dst, const void *src, size_t len);

// other rom functions
int ets_printf(const char *fmt, ...);
int uart_tx_one_char(uint8_t TxChar);
int uart_rx_one_char(uint8_t *pRxChar);
void esp_rom_spiflash_attach(uint32_t ishspi, bool legacy);
int esp_rom_spiflash_read(uint32_t src_addr, uint32_t *dest, int32_t len);
int esp_rom_spiflash_config_param(uint32_t deviceId, uint32_t chip_size, uint32_t block_size, uint32_t sector_size, uint32_t page_size, uint32_t status_mask);
