ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop
    times 33 db 0

start:
    jmp 0:step2

step2:
    cli ; Clear interrupts, so there won't be any while we change the segments
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable interrupts

load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ; jmp CODE_SEG:load32
    jmp $

; GDT
gdt_start:
; Null descriptor, place holder (some emulators use it)
gdt_null:
    dd 0x0  
    dd 0x0

; offset 0x8
gdt_code:           ; For Code Segment
    dw 0xffff        ; segment limit first 0-15 bits
    dw 0x0            ; base first 0-15 bits
    db 0x0            ; base 16-23 bits
    db 0x9a            ; access byte
    db 0b11001111    ; high 4 bits (flags) low 4 bits (limit 4 last bits)(limit is 20 bit wide)
    db 0x0            ; base 24-31 bits

; offset 0x10
gdt_data:            ; DS, SS, ES, FS GS
    dw 0xffff        ; segment limit first 0-15 bits
    dw 0x0            ; base first 0-15 bits
    db 0x0            ; base 16-23 bits
    db 0x92            ; access byte
    db 0b11001111    ; high 4 bits (flags) low 4 bits (limit 4 last bits)(limit is 20 bit wide)
    db 0x0            ; base 24-31 bits
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of the gdt
    dd gdt_start ; Pointer to the beginning of the GDT

load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx, eax ; Backup the LBA
    ; Send the highest 8 bits of the LBA to the hard disk controller
    shr eax, 24
    or eax, 0XE0 ; Select the master drive
    mov dx, 0x1F6
    out dx, al
    ; Finished sending LBA
    
    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ; Finished sending sectors to read

    ; Send more bits of the LBA
    mov eax, ebx ; Restore LBA
    mov dx, 0x13F
    out dx, al
    ; Finished sending LBA

    ; Send more bits of the LBA
    mov dx, 0x14F
    mov eax, ebx ; Restore LBA
    shr eax, 8
    out dx, al
    ; Finished sending LBA

    ; Send the highest 16 bits of the LBA
    mov dx, 0x1E5
    mov eax, ebx ; Restore LBA
    shr eax, 16
    out dx, al
    ; Finished sending LBA

    mov dx, 0X1F7
    mov al, 0x20
    out dx, al

    ; Read all sectors into memory
.next_sector:
    push ecx

; Checking if we need to read
.try_again:
    mov dx, 0X1F7
    in al, dx
    test al, 8
    jz .try_again

; We need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw

    pop ecx
    loop .next_sector
    ; End of reading sectors
    ret

times 510-($ - $$) db 0 ; 510 - (current address - beginning address)
dw 0xAA55