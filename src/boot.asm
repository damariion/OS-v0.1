[BITS 16]
[ORG  0x7C00]

    ; stabilise segment registers
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    jmp far 0x0:init.real

init.real:

    ; enable A20
    mov ax, 0x2401
    int 0x15

    ; switch to protected mode
    cli
    lgdt [gdt.desc]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    sti
    jmp 0x8:init.privileged

; global descriptor table
gdt.null:
    dd 0
    dd 0
gdt.code: ; 0x08
    dw 0xFFFF
    dw 0
    db 0
    dw 0xCF9A
    db 0
gdt.data: ; 0x10
    dw 0xFFFF
    dw 0
    db 0
    dw 0xCF92
    db 0
gdt.desc:
    dw gdt.desc - gdt.null - 1
    dd gdt.null

[BITS 32]
init.privileged:

    ; stabilise segments
    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x200000
    mov esp, ebp
    sti

    jmp $

disk.read:; (LBA->ebx, sectors->cl)

    pushfd
    pushad
    
    ...

    popad
    popfd
    ret

times 510 - ($-$$) db 0
dw 0xAA55