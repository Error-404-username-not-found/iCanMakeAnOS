Barebone OS building Steps:-
- Build a bootloader in NASM (512 bytes) that loads and starts the kernel
- Kernel Core	Memory setup, hardware abstraction
- Interrupt Handling	Basic CPU and device interrupt support
- I/O	VGA/serial output, keyboard input
- Process Handling (opt.)	Run a task or process
- System Call Interface	Optional communication to kernel

Bootloading sequence:-
- Power on → BIOS runs POST (Power-On Self-Test).
- BIOS finds bootable device (e.g., hard drive, USB).
- Reads first sector (512 bytes) into memory at 0x7C00.
- Jumps to 0x7C00 and starts executing → your bootloader.
