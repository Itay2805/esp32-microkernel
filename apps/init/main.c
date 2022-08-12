#include <syscall.h>

void _start() {
    sys_log("Hello world!", sizeof("Hello world!") - 1);
}
