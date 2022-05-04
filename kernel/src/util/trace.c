#include "trace.h"

#include <drivers/uart.h>

void _putchar(char character) {
    uart_write_char(character);
}
