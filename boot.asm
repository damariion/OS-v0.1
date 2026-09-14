BITS 16
ORG  0x7C00

%%macro console.write 1
    lodsb
    cmp al, 0
    je .done
    mov ah, 0xE
    mov bx, 0
    mov si, %1
    int 0x10
    jmp console.write
%endmacro

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    
    jmp far 0x0:main

main:

    mov cl, 2
    mov bx, buffer
    call disk.read

    console.write buffer

    jmp $

disk.read:;(sector->cl, output->bx)
    mov ah, 0x2
    mov al, 1
    mov ch, 0
    mov dh, 0
    int 0x13
    ret

times 510 - ($-$$) db 0
dw 0xAA55

buffer: