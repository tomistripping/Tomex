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
    jmp CODE_SEG:load32

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

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    
    ; Enable the A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $

times 510-($ - $$) db 0 ; 510 - (current address - beginning address)
dw 0xAA55