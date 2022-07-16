ORG 0
BITS 16
_start:
    jmp short start
    nop

times 33 db 0

; IVT interrupts snippet
; handle_zero:
;     mov ah, 0eh
;     mov al, 'A'
;     mov bx, 0
;     int 0x10
;     iret
; handle_one:
;     mov ah, 0eh
;     mov al, 'V'
;     mov bx, 0
;     int 0x10
;     iret

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

    ; IVT interrupts snippet write to 0x00
    ; mov word[ss:0x00], handle_zero
    ; mov word[ss:0x02], 0x7c0
    ; mov word[ss:0x04], handle_one
    ; mov word[ss:0x06], 0x7c0
    ; int 0
    ; int 1

    mov si, helloWorldStr
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

helloWorldStr: db "David Gever Rezach!", 0

times 510-($ - $$) db 0
dw 0xAA55