// from https://gitlab.com/qookei/quack

#include "trace.h"
#include "rom.h"

#include <stdint.h>

void trace_hex(const void* _data, size_t size) {
    const uint8_t* data = _data;
    char ascii[17] = { 0 };

    ets_printf("[*] ");
    for (int i = 0; i < size; i++) {
        ets_printf("%02x ", data[i]);

        if (data[i] >= ' ' && data[i] <= '~') {
            ascii[i % 16] = data[i];
        } else {
            ascii[i % 16] = '.';
        }

        if ((i + 1) % 8 == 0 || i + 1 == size) {
            ets_printf(" ");
            if ((i + 1) % 16 == 0) {
                ets_printf("|  %s \n", ascii);
                if (i + 1 != size) {
                    ets_printf("[*] ");
                }
            } else if (i + 1 == size) {
                ascii[(i + 1) % 16] = '\0';
                if ((i + 1) % 16 <= 8) {
                    ets_printf(" ");
                }
                for (int j = (i + 1) % 16; j < 16; ++j) {
                    ets_printf("   ");
                }
                ets_printf("|  %s \n", ascii);
            }
        }
    }
}

void __assert_func(const char* filename, int line, const char* func, const char* expression) {
    ERROR("Assert `%s` failed at %s (%s:%d)", expression, func, filename, line);
    while(1);
}