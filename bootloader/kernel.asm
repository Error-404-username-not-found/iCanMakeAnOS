[org 0xAAAA]

start:
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je hang
    
    mov ah, 0x0E
    int 0x10
    jmp print_loop

hang:
    cli
    hlt
    jmp hang

message db 'Copyright (c) 2025 A&J Kernel Inc.', 0

times 5120 - ($ - $$) db 0