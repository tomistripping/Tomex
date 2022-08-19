#include "kernel.h"
#include <stdint.h>

uint16_t terminal_make_char(char c, char color) {
    return (color << 8) | c;
}

void kernel_main() {
    uint16_t* video_mem = (uint16_t*)(0xB8000);
    video_mem[0] = terminal_make_char('T', 5);
    video_mem[1] = terminal_make_char('a', 3);
}
