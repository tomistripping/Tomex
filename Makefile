BOOTBIN = ./bootloader/boot.bin

all:
	nasm -f bin bootloader/boot.asm -o $(BOOTBIN)
	dd if=./message.txt >> $(BOOTBIN)
	dd if=/dev/zero bs=512 count=1 >> $(BOOTBIN)
