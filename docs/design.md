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

## Intel x64 registers
Alright, let’s do **the full x86/x86-64 register map** — grouped by category — and I’ll explain what each one actually does, from ancient 16-bit days to modern 64-bit usage.

### **1. General-Purpose Registers (GPRs)**

These hold integer data, pointers, counters, function arguments, return values, etc.

| 64-bit | 32-bit   | 16-bit   | 8-bit    | Purpose                                        |
| ------ | -------- | -------- | -------- | ---------------------------------------------- |
| RAX    | EAX      | AX       | AL/AH    | Accumulator — math ops, function return values |
| RBX    | EBX      | BX       | BL/BH    | Base register — historically data pointer      |
| RCX    | ECX      | CX       | CL/CH    | Counter — loops, shifts, string instructions   |
| RDX    | EDX      | DX       | DL/DH    | Data register — I/O, math, division remainder  |
| RSI    | ESI      | SI       | SIL      | Source index for string/memory ops             |
| RDI    | EDI      | DI       | DIL      | Destination index for string/memory ops        |
| RSP    | ESP      | SP       | SPL      | Stack pointer                                  |
| RBP    | EBP      | BP       | BPL      | Base pointer (stack frame reference)           |
| R8–R15 | R8D–R15D | R8W–R15W | R8B–R15B | Extra general-purpose registers in 64-bit mode |

* **Note:** Writing to the 32-bit reg (e.g., `EAX`) zeroes the upper 32 bits of the 64-bit reg (`RAX`).
* **High 8-bit registers** (AH, BH, CH, DH) are legacy; SPL/BPL/SIL/DIL and R8B–R15B were added in x86-64.

### **2. Segment Registers**

Hold *segment selectors* — used with an offset to calculate a physical/linear address.

| Register | Purpose                                                                 |
| -------- | ----------------------------------------------------------------------- |
| CS       | Code Segment — where instructions are fetched from                      |
| DS       | Data Segment — default for most memory accesses                         |
| ES       | Extra Segment — extra data space, used by string/mem ops as destination |
| SS       | Stack Segment — where the stack lives                                   |
| FS       | General-purpose extra segment (modern: Thread Local Storage pointer)    |
| GS       | General-purpose extra segment (modern: often kernel data base pointer)  |

* **Modern 64-bit reality:** CS, DS, ES, SS are mostly fixed to flat addressing; FS and GS still used.

### **3. Instruction Pointer**

Points to the next instruction to execute.

| 64-bit | 32-bit | 16-bit |
| ------ | ------ | ------ |
| RIP    | EIP    | IP     |

* RIP-relative addressing in x86-64 lets you access nearby data without hardcoding full addresses.

### **4. Flags Register**

Stores status and control flags.

| 64-bit | 32-bit | 16-bit |
| ------ | ------ | ------ |
| RFLAGS | EFLAGS | FLAGS  |

Key bits:

* **CF** (Carry Flag) — arithmetic carry/borrow
* **ZF** (Zero Flag) — result was zero
* **SF** (Sign Flag) — result negative
* **OF** (Overflow Flag) — signed overflow
* **IF** (Interrupt Enable) — allows CPU interrupts
* **DF** (Direction Flag) — string ops increment/decrement indexes

### **5. Floating-Point Unit (x87 FPU)**

Legacy floating-point registers.

| Register | Purpose                                                 |
| -------- | ------------------------------------------------------- |
| ST0–ST7  | 80-bit floating-point registers in a stack-based layout |

* Still there, but replaced by SSE/AVX in modern code.

### **6. MMX Registers** (Integer SIMD, legacy)

| Register | Purpose                                           |
| -------- | ------------------------------------------------- |
| MM0–MM7  | 64-bit integer SIMD registers, alias with ST0–ST7 |

### **7. SSE / AVX / AVX-512 Registers**

Modern SIMD (vector) registers.

| Register   | Width   | Purpose                              |
| ---------- | ------- | ------------------------------------ |
| XMM0–XMM31 | 128-bit | SSE floating-point & integer vectors |
| YMM0–YMM31 | 256-bit | AVX vectors (extend XMM)             |
| ZMM0–ZMM31 | 512-bit | AVX-512 vectors (extend YMM)         |

### **8. Control Registers**

Control CPU modes and paging.

| Register | Purpose                                       |
| -------- | --------------------------------------------- |
| CR0      | Enables/disables protected mode, paging, etc. |
| CR2      | Stores page fault linear address              |
| CR3      | Holds page directory/table base address       |
| CR4      | Enables extra features (PSE, PAE, SSE, etc.)  |
| CR8      | Task priority register (x86-64 only)          |

### **9. Debug Registers**

Used for hardware breakpoints.

| Register | Purpose              |
| -------- | -------------------- |
| DR0–DR3  | Breakpoint addresses |
| DR6      | Debug status         |
| DR7      | Debug control        |

### **10. Task Register**

| Register | Purpose                                                             |
| -------- | ------------------------------------------------------------------- |
| TR       | Holds TSS (Task State Segment) selector for hardware task switching |

### **11. Model-Specific Registers (MSRs)**

Special registers accessed via `RDMSR`/`WRMSR` for CPU configuration.
Examples: IA32\_APIC\_BASE, IA32\_LSTAR (syscall entry), etc.

#### TL;DR memory trick:

Think of x86 registers in **layers**:

1. *You* (programmer) mainly touch **GPRs, RIP, FLAGS**
2. OS and compilers also mess with **FS/GS**, control regs, SIMD regs
3. The rest (segment regs, x87, MMX) are mostly legacy
