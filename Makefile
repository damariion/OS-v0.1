everything:
	nasm -f bin boot.asm -o bin/boot.bin
	dd if=bin/disk.iso >> bin/boot.bin
	dd if=/dev/zero bs=512 count=1 >> bin/boot.bin
	truncate -s 1k bin/boot.bin