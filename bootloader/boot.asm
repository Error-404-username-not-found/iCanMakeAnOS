; ------------------------------------------------------------
; Simple Bootloader: Prints a message in Real Mode (NASM Syntax)
; ------------------------------------------------------------

[org 0x7C00]         ; BIOS loads boot sector here

start:
    mov si, message  ; Load address of the string into SI

print_loop:
    lodsb            ; AL = [SI], SI++
    cmp al, 0        ; End of string?
    je hang

    mov ah, 0x0E     ; BIOS teletype function
    int 0x10         ; Print AL to screen
    jmp print_loop   ; Repeat for next char

; -----------------------
; End of Message Handling
; -----------------------

hang:
    cli              ; Disable interrupts
    hlt              ; Halt CPU
    jmp hang         ; Stay here forever

; -----------------------
; Data Section
; -----------------------

message db 'Copyright (c) 2025 Abesh & Jayanta Inc.'  ; Null-terminated string

; -----------------------
; Boot Sector Padding & Signature
; -----------------------

times 510 - ($ - $$) db 0   ; Pad to 510 bytes
dw 0xAA55                   ; Boot signature
