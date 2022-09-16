#include "kernel.h"
#include <stdint.h>
#include <stddef.h>

uint16_t* video_mem = 0;
uint16_t terminal_row = 0;
uint16_t terminal_col = 0;

uint16_t terminal_make_char(char c, char color) {
    return (color << 8) | c;
}

void terminal_putchar(int x, int y, char c, char color) {
    video_mem[(y * VGA_WIDTH) + x] = terminal_make_char(c, color);
}

void terminal_writechar(char c, char color) {
    if (c == '\n') {
        terminal_row++;
        terminal_col = 0;
        return;
    }

    terminal_putchar(terminal_col++, terminal_row, c, color);
    if (terminal_col >= VGA_WIDTH) {
        terminal_row++;
        terminal_col = 0;
    }
}

void terminal_init() {
    video_mem = (uint16_t*)(0xB8000);
    terminal_row = 0;
    terminal_col = 0;
    for (int y = 0; y < VGA_HEIGHT; y++) {
        for (int x = 0; x < VGA_WIDTH; x++) {
            terminal_putchar(x, y, ' ', 0);
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

void terminal_puts_old(int x, int y, const char* str, char color, short int colorful) {
    int const_strlen = strlen(str);
    for (int curr_iteration = 0; curr_iteration < const_strlen; curr_iteration++) {
        terminal_putchar(x + curr_iteration, y, str[curr_iteration], (colorful ? (((color++) + 1) % 16) : color));
    }
}

void terminal_puts(const char* str, char color) {
    int const_strlen = strlen(str);
    for (int curr_iteration = 0; curr_iteration < const_strlen; curr_iteration++) {
        terminal_writechar(str[curr_iteration], color);
    }
}

void print(const char* str) {
    terminal_puts(str, 15);
}

void kernel_main() {
    terminal_init();
    // terminal_puts_old(0, 0, "Test tomer king!Test tomer king!Test tomer king!Test tomer king!", 0, 1);
    print("Hello!\nHow are you today?");
}
