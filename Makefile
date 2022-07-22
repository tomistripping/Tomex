BOOTBIN = ./bootloader/boot.bin

all:
	nasm -f bin bootloader/boot.asm -o $(BOOTBIN)
