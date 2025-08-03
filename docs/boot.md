# 🧠 Bootloader Assembly Code Breakdown (Real Mode, NASM Syntax)

### `[org 0x7C00]`

* Tells the assembler this code will be loaded at memory address `0x7C00`.
* Why? Because the **BIOS loads the boot sector** into this address by default.

### `start:`

* A **label** marking the beginning of the bootloader's execution.
* Useful for `jmp` instructions and readability.

### `mov si, message`

* Loads the address of the `message` string into the `SI` register.
* Sets up for looping through the string using `lodsb`.

### `print_loop:`

* Label marking the start of the character-printing loop.

### `lodsb`

* Loads a byte from memory at `[SI]` into `AL`, then increments `SI`.
* Equivalent to:

  ```asm
  mov al, [si]
  inc si
  ```

### `cmp al, 0`

* Compares the byte in `AL` with `0`.
* We're checking for the **null terminator** to detect the end of the string.

### `je hang`

* Jumps to `hang` if `AL == 0` — i.e., end of string.
* Halts the program after printing is done.

### `mov ah, 0x0E`

* Prepares to call **BIOS teletype service** (`int 0x10`, function 0x0E).
* `AH = 0x0E` tells BIOS to print the character in `AL`.

### `int 0x10`

* Calls BIOS interrupt `0x10`, using the function specified in `AH`.
* With `AH = 0x0E`, it **prints the character in AL to the screen**.

### `jmp print_loop`

* Jumps back to `print_loop:` to print the next character.

## 🔁 End of Message Handling

### `hang:`

* Label for halting the CPU after the message is done printing.

### `cli`

* **Clear Interrupts**: disables all hardware interrupts.
* Prevents unexpected CPU behavior before halting.

### `hlt`

* **Halt** the CPU — stops execution until the next hardware interrupt (which won’t come since interrupts are off).

### `jmp hang`

* Infinite loop to keep the CPU in a halted state.
* Prevents it from running into garbage memory after `hlt`.

## 📝 Message Declaration

### `message db 'Hello from bootloader!', 0`

* Defines a **null-terminated string**.
* `0` at the end marks where the string ends (for `cmp al, 0` to work).

## 🧱 Boot Sector Padding & Signature

### `times 510-($-$$) db 0`

* Pads the file with zeros so total size becomes **510 bytes**.
* `$` = current position, `$$` = start of the file.

### `dw 0xAA55`

* The **magic boot signature** required by the BIOS.
* Must be at bytes **511–512** of the boot sector.
* If missing, BIOS won’t consider the sector bootable.