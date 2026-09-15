LDFLAGS = -T linker.ld
GCFLAGS = -g -O0 -ffreestanding -nostdlib -I src/include -Wall -Wextra $(NSFLAGS)

BIN_DIR = bin
SRC_DIR = src

OUTPUT_PATH = $(BIN_DIR)/out/os-build-0.3.iso
OBJECT_TREE = $(BIN_DIR)/load_c.o $(BIN_DIR)/kernel.o
BINARY_TREE = $(BIN_DIR)/booter.bin $(BIN_DIR)/kernel.bin

build: booter.bin kernel.bin
	mkdir -p bin/out
	dd if=$(BIN_DIR)/booter.bin bs=512 count=1  > $(OUTPUT_PATH)
	dd if=$(BIN_DIR)/kernel.bin bs=512 count=1 >> $(OUTPUT_PATH)
	dd if=/dev/zero bs=512 count=1 >> $(OUTPUT_PATH)
	truncate -s $(shell echo $$((2 * 512))) $(OUTPUT_PATH)

kernel.bin: load_c.o kernel.o
	i686-elf-ld $(LDFLAGS) $(OBJECT_TREE) -o $(BIN_DIR)/kernel.bin
booter.bin:
	nasm -f bin $(SRC_DIR)/.boot/booter.asm -o $(BIN_DIR)/booter.bin

load_c.o:
	nasm -f elf $(SRC_DIR)/.boot/load_c.asm -o $(BIN_DIR)/load_c.o
kernel.o:
	i686-elf-gcc $(GCFLAGS) -std=gnu99 -c $(SRC_DIR)/kernel.c -o $(BIN_DIR)/kernel.o

clean:
	rm -rf $(BINARY_TREE) $(OBJECT_TREE)