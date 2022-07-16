ORG 0
BITS 16
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

step2:
    cli ; Clear Interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0
    mov ss, ax
    mov sp, 0x7c00
    sli ; Enables Interrupts

    mov ah, 2 ; READ SECTOR COMMAND
    mov al, 1 ; ONE SECTOR TO READ
    mov ch, 0 ; Cylinder low 8 bits
    mov cl, 2 ; READ SECTOR 2
    mov dh, 0 ; HEAD NUMBER
    mov bx, buffer ; Where to read
    int 0x13
    jc error

    mov si, buffer
    call print
    jmp $

error:
    mov si, error_message
    call print
    jmp $

print:
.loop:
    mov bx, 0
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop

.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed to load sector', 0

times 510-($ - $$) db 0
dw 0xAA55

buffer: