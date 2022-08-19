#include <syscall.h>

static char buffer[6];

void _start() {
    buffer[0] = 'H';
    buffer[1] = 'e';
    buffer[2] = 'l';
    buffer[3] = 'l';
    buffer[4] = 'o';
    buffer[5] = '!';
    sys_log(buffer, sizeof(buffer));
    while(1);
}
