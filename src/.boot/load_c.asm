BITS 32
extern kmain

    call kmain
    jmp $

times 32 - ($-$$) db 0