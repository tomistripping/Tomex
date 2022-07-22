BOOTASM = src/boot/boot.asm
BOOTBIN = ./bin/boot.bin

all:
	nasm -f bin $(BOOTASM) -o $(BOOTBIN)

clean:
	rm -rf $(BOOTBIN)
