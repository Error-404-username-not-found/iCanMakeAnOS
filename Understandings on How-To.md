## Barebone OS building Steps:-
- Build a bootloader in NASM (512 bytes) that loads and starts the kernel
- Kernel Core	Memory setup, hardware abstraction
- Interrupt Handling	Basic CPU and device interrupt support
- I/O	VGA/serial output, keyboard input
- Process Handling (opt.)	Run a task or process
- System Call Interface	Optional communication to kernel

## Bootloading sequence:-
- Power on → BIOS runs POST (Power-On Self-Test).
- BIOS finds bootable device (e.g., hard drive, USB).
- Reads first sector (512 bytes) into memory at 0x7C00.
- Jumps to 0x7C00 and starts executing → your bootloader.

What does `gcc` do?
- When you run:
```bash
gcc hello.c -o hello
```

You're not just calling one tool. gcc is a driver program — it internally calls:
1. Preprocessor – cpp
2. Compiler – cc12
3. Assembler – as (or i686-elf-as if cross)
4. Linker – ld (or i686-elf-ld if cross)

## Source to binary executable pipeline
```
hello.c 
   ⬇ (Preprocessing: expands macros & #includes done by C-Pre-Processor)
hello.i 
   ⬇ (Compilation: translates C to Assembly done by Compiler)
hello.s 
   ⬇ (Assembly: assembles to object code done by Assembler)
hello.o 
   ⬇ (Linking: produces final executable done why Linker)
hello (ELF binary or .exe)
```
