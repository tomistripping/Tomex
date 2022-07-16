all:
	nasm -f bin bootloader/boot.asm -o ./bootloader/boot.bin
