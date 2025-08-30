BUILD_PATH='../build'

nasm -f bin boot.asm -o $BUILD_PATH/boot.bin

nasm -f elf32 kernel.asm -o $BUILD_PATH/kernel_asm.o
i686-elf-gcc -Wno-int-conversion -c kernel.c -o $BUILD_PATH/kernel_c.o
i686-elf-ld --oformat=binary -T linker.ld $BUILD_PATH/kernel_c.o $BUILD_PATH/kernel_asm.o -o $BUILD_PATH/kernel.bin

dd if=$BUILD_PATH/boot.bin of=$BUILD_PATH/bare_os.img count=1 bs=512 conv=notrunc

dd if=$BUILD_PATH/kernel.bin of=$BUILD_PATH/bare_os.img count=10 bs=512 seek=1 conv=notrunc