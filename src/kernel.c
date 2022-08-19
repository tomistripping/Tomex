#include "kernel.h"

void kernel_main() {
    char* video_mem = (char*)(0xB8000);
    video_mem[0] = 'T';
    video_mem[1] = 1;
    video_mem[2] = 'o';
    video_mem[3] = 2;
    video_mem[4] = 'm';
    video_mem[5] = 3;
    video_mem[6] = 'e';
    video_mem[7] = 4;
    video_mem[8] = 'r';
    video_mem[9] = 5;
}
