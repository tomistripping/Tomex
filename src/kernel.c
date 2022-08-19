#include "kernel.h"
#include <stdint.h>
#include <stddef.h>

uint16_t* video_mem = 0;

uint16_t terminal_make_char(char c, char color) {
    return (color << 8) | c;
}

void terminal_init() {
    video_mem = (uint16_t*)(0xB8000);
    for (int y = 0; y < VGA_HEIGHT; y++) {
        for (int x = 0; x < VGA_WIDTH; x++) {
            video_mem[(y * VGA_WIDTH) + x] = terminal_make_char(' ', 0);
        }
    }
}

size_t strlen(const char* str) {
    size_t len = 0;
    while (str[len]) {
        len++;
    }

    return len;
}

void terminal_putchar(int x, int y, char c, char color) {
    video_mem[(y * VGA_WIDTH) + x] = terminal_make_char(c, color);
}

void terminal_puts(int x, int y, const char* str, char color, short int colorful) {
    int const_strlen = strlen(str);
    for (int curr_iteration = 0; curr_iteration < const_strlen; curr_iteration++) {
        terminal_putchar(x + curr_iteration, y, str[curr_iteration], (colorful ? (((color++) + 1) % 16) : color));
    }
}

void kernel_main() {
    terminal_init();
    terminal_puts(0, 0, "Test tomer king!Test tomer king!Test tomer king!Test tomer king!", 0, 1);
}
