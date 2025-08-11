## Barebone OS building Steps:-

### **1. Define OS Goals**

* What is it for? (PC, embedded, hobby, etc.)
* GUI or command-line?
* Unique features?

### **2. Set Up Development Environment**

* Install a compiler (like GCC)
* Use an emulator (like QEMU or VirtualBox)
* Set up cross-compiling tools


### **3. Choose a Programming Language**

* Usually C and Assembly
* Optionally C++, Rust, or others


### **4. Create a Bootloader**

* Use GRUB or write your own
* Loads your OS kernel into memory


### **5. Write the Kernel**

* Handle memory management
* Handle CPU scheduling
* Handle basic I/O (keyboard, screen)


### **6. Add Drivers**

* Keyboard, display, disk, etc.


### **7. Build File System Support**

* FAT, ext2, or your own


### **8. Create a Shell or GUI**

* Basic command interface or graphics window system


### **9. Build User Programs Support**

* Allow programs to run on your OS


### **10. Test, Debug, and Improve**

* Use QEMU and real hardware testing
* Fix bugs, improve performance, add features



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

## Assembly commands to move data
```
mov byte [...] → move 1 byte

mov word [...] → move 2 bytes (16 bits)

mov dword [...] → move 4 bytes (32 bits)

mov qword [...] → move 8 bytes (64 bits)
```

## First 1 MB of RAM used in Real mode

| Hex Address Range   | Decimal Address Range | Memory Size Approx. | Memory Range (KB)   | Description                     |
| ------------------- | --------------------- | ------------------- | ------------------- | ------------------------------- |
| `0x00000–0x003FF`   | 0 – 1,023             | 1 KB                | 0 KB – 1 KB         | Interrupt Vector Table (IVT)    |
| `0x00400–0x004FF`   | 1,024 – 1,279         | 256 bytes           | 1 KB – 1.25 KB      | BIOS Data Area (BDA)            |
| `0x00500–0x07BFF`   | 1,280 – 31,359        | \~30 KB             | 1.25 KB – 30.67 KB  | Generally safe for code/data    |
| `0x07C00–0x07DFF`   | 31,360 – 31,871       | 512 bytes           | 30.67 KB – 30.93 KB | Bootloader loaded here          |
| `0x07E00–0x09FFFF`  | 31,872 – 655,359      | 623 KB              | 30.93 KB – 640 KB   | Usually Reserved/Hardware areas |
| `0x0A0000–0x0FFFFF` | 655,360 – 1,048,575   | 384 KB              | 640 KB – 1,024 KB   | Video memory, BIOS ROM, etc.    |
