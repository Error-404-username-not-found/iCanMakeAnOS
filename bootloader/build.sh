nasm -f bin boot.asm -o ../build/boot.bin

nasm -f elf32 kernel.asm -o ../build/kernel_asm.o
i686-elf-gcc -Wno-int-conversion -c kernel.c -o ../build/kernel_c.o
i686-elf-ld --oformat=binary -T linker.ld ../build/kernel_c.o ../build/kernel_asm.o -o ../build/kernel.bin

dd if=../build/boot.bin of=../build/bare_os.img count=1 bs=512 conv=notrunc

dd if=../build/kernel.bin of=../build/bare_os.img count=10 bs=512 seek=1 conv=notrunc