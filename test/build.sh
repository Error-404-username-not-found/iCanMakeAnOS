nasm -f bin boot.asm -o boot.bin

nasm -f bin kernel.asm -o kernel.bin

dd if=boot.bin of=mydisk.img count=1 bs=512 conv=notrunc

dd if=kernel.bin of=mydisk.img count=10 bs=512 seek=1 conv=notrunc