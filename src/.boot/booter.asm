[BITS 16]
[ORG  0x7C00]

    cli ; disable interrupts
    
    ; stabilise segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    jmp far 0x0:init.real

init.real:

    ; enable A20
    mov ax, 0x2401
    int 0x15

    ; switch to protected mode
    lgdt [gdt.desc]
    mov eax, cr0
    or al, 1
    mov cr0, eax

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
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x5000
    mov esp, ebp

    ; place kernel in memory
    mov ebx, 1
    mov ecx, 2
    mov edi, 0x10000
    call disk.read

    jmp edi

disk.read:; (sector->ebx, count->ecx, output->edi)

    pushfd
    pushad
    
    ; set: drive + LBA[24:]
    mov edx, 0x1F6
    mov eax, ebx
    shr eax, 24
    or al, 0xE0
    out dx, al

    ; set: sector count
    mov edx, 0x1F2
    mov al, cl
    out dx, al

    ; set: LBA[:7]
    mov edx, 0x1F3
    mov eax, ebx
    out dx, al

    ; set: LBA[8:15]
    mov edx, 0x1F4
    mov eax, ebx
    shr eax, 8
    out dx, al

    ; set: LBA[16:23]
    mov edx, 0x1F5
    mov eax, ebx
    shr eax, 16
    out dx, al

    ; call: read with retry
    mov edx, 0x1F7
    mov al, 0x20
    out dx, al

.await:

    ; test: DRQ set?
    in al, dx
    test al, 8
    jz .await

    ; copy: sectors
    mov eax, 256
    mul ecx
    mov ecx, eax
    mov edx, 0x1F0
    cld
    rep insw

    popad
    popfd
    ret

times 510 - ($-$$) db 0
dw 0xAA55