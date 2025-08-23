; ------------------------------------------------------------
; Simple Bootloader: Prints a message in Real Mode (NASM Syntax)
; ------------------------------------------------------------

[org 0x7C00]         ; BIOS loads boot sector here

start:
    mov si, message  ; Load address of the string into SI

print_loop:
    lodsb            ; AL = [SI], SI++
    cmp al, 0        ; End of string?
    je print_done

    mov ah, 0x0E     ; BIOS teletype function
    int 0x10         ; Print AL to screen
    jmp print_loop   ; Repeat for next char

; -----------------------
; End of Message Handling
; -----------------------

print_done:
    call enable_a20
    call load_kernel_sectors
    call load_gdt
    call enable_pmode
    jmp 0x08:pmode_main

enable_a20:
    mov ax, 0x2401
    int 0x15
    ret

load_kernel_sectors:
    ; define start location of kernel in RAM
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0000
    
    ; request BIOS read mode
    mov ah, 0x02
    
    ; define start location of kernel in secondary memory
    mov ch, 0            ; Cylinder
    mov cl, 2            ; Start reading at sector 2
    mov dh, 0            ; Head
    mov dl, 0x80         ; BOOT DRIVE

    ; define copy size (of kernel)
    mov al, 10           ; 10 sectors = 10 * 512 bytes 

    ; do BIOS read from disk
    int 0x13
    ret

gdt_start:
    dq 0x0000000000000000        ; null descriptor (mandatory)
    dq 0x00CF9A000000FFFF        ; code segment descriptor 
    dq 0x00CF92000000FFFF        ; data segment descriptor
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

load_gdt:
    cli
    lgdt [gdt_descriptor]          ; load the GDTR register with GDT addr
    ret

enable_pmode:
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ret

; --------------------------
; 32-bit Protected mode code
; --------------------------

[BITS 32]
pmode_main:
    ; Load data segments with data selector (0x10)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Setup stack pointer (pick some high memory address)
    mov esp, 0x9FC00       ; just below 640KB mark (safe zone for stack)

    ; jump to kernel entry
    jmp 0x00010000

; -----------------------
; Data Section
; -----------------------

message db 'Copyright (c) 2025 A&J Bootloaders Inc.', 0xa, 0xd, 0  ; Null-terminated string

; -----------------------
; Boot Sector Padding & Signature
; -----------------------

times 510 - ($ - $$) db 0   ; Pad to 510 bytes
dw 0xAA55                   ; Boot signature
