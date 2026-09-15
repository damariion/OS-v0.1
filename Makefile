SECTOR = bs=512 count=1

build: boot.bin krnl.bin
	dd if=./bin/boot.bin $(SECTOR) > ./bin/os.bin
	dd if=./bin/krnl.bin $(SECTOR) >> ./bin/os.bin
	$(MAKE) clean

clean:
	rm -rf ./bin/boot.bin
	rm -rf ./bin/krnl.bin
	rm -rf ./bin/krnl.o
	rm -rf ./bin/krnl.asm.o

boot.bin:
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin

krnl.bin:
	nasm -f elf -g -o ./bin/krnl.asm.o ./src/krnl.asm 
	i686-elf-ld -g -relocatable -o ./bin/krnl.o ./bin/krnl.asm.o
	i686-elf-gcc -ffreestanding -O0 -nostdlib -T link.ld -o ./bin/krnl.bin ./bin/krnl.o