; ------------------------------------------------------------
; Simple Bootloader: Prints a message in Real Mode (NASM Syntax)
; ------------------------------------------------------------

[org 0x7C00]         ; BIOS loads boot sector here

start:
    mov si, message  ; Load address of the string into SI

print_loop:
    lodsb            ; AL = [SI], SI++
    cmp al, 0        ; End of string?
    je load_kernel_sectors

    mov ah, 0x0E     ; BIOS teletype function
    int 0x10         ; Print AL to screen
    jmp print_loop   ; Repeat for next char

load_kernel_sectors:
    ; define start location of kernel in RAM
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x7e00
    
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
    
    ; jump to kernel
    jmp kerstart

; -----------------------
; Data Section
; -----------------------

message db 'Copyright (c) 2025 A&J Bootloaders Inc.', 0xa, 0xd, 0  ; Null-terminated string

; -----------------------
; Boot Sector Padding & Signature
; -----------------------

times 510 - ($ - $$) db 0   ; Pad to 510 bytes
dw 0xAA55                   ; Boot signature

kerstart:
    mov si, kermessage

kerprint_loop:
    lodsb
    cmp al, 0
    je kerhang

    mov ah, 0x0E
    int 0x10
    jmp kerprint_loop

kerhang:
    cli
    hlt
    jmp kerhang

kermessage db 'Copyright (c) 2025 A&J Kernel Inc.', 0