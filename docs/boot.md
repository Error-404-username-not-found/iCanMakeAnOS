[org 0x7C00]
Tells the assembler that this code will be loaded at memory address 0x7C00.
Why? Because that's where the BIOS loads the boot sector by default.

start:
A label marking the beginning of your bootloader’s execution. It’s useful for jumps and clarity.

mov si, message
Loads the address of the message string into register SI.
This sets up for looping through the string using lodsb.

print_loop:
Label used as the start of the print loop. We'll jump back here after printing each character.

lodsb
Loads a byte from the address in SI into AL, and increments SI.
It's shorthand for:

asm
Copy
Edit
mov al, [si]
inc si
We're reading the next character from the message.

cmp al, 0
Compares the character in AL with 0.
If it’s 0, we’ve reached the end of the string (null terminator).

je hang
If cmp found that AL is 0, this means the message is done — so we jump to hang: to stop.

mov ah, 0x0E
Sets AH = 0x0E, which is the BIOS teletype function (int 0x10).
This function prints the character in AL to the screen.

int 0x10
Calls BIOS video interrupt — in this case, using function 0x0E to print the character.

jmp print_loop
Jumps back to print_loop: to get the next character and repeat the process.

hang:
Label where we go when the message is done printing — this is where the bootloader halts.

cli
Clear Interrupts — disables hardware interrupts.
Good practice before halting to prevent unexpected CPU activity.

hlt
Halt CPU — puts the CPU into a stopped state until the next external interrupt (which won’t come, since interrupts are disabled).

jmp hang
Infinite loop — keeps jumping back to hang to halt forever.
Prevents the CPU from running into garbage memory after hlt.

message db 'Hello from bootloader!', 0
Defines the string to print. Ends with a 0 (null terminator) so we know when to stop.

times 510-($-$$) db 0
Pads the rest of the boot sector (up to 510 bytes) with zeros.

$ is current position

$$ is the start of the file
This ensures total size = 510 bytes before adding boot signature.

dw 0xAA55
This is the boot signature that BIOS looks for.
It must be the last 2 bytes (bytes 511–512).
If it’s missing, the BIOS won’t treat the sector as bootable.