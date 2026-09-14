BITS 16
ORG  0x7C00

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    jmp 0x0:start

start:

    mov si, message
    call iostr

    jmp $

iochr:
    mov ah, 0xE
    mov bx, 0
    int 0x10
    ret

iostr:
    lodsb
    cmp al, 0
    je .done
    call iochr
    jmp iostr
.done:
    ret

message: db "Hello, World!", 0

times 510 - ($-$$) db 0
dw 0xAA55