make
gdb \
    -ex "set confirm off" \
    -ex "target remote | qemu-system-x86_64 -hda bin/out/OS-v0.1.iso -S -gdb stdio" \
    -ex "add-symbol-file bin/kernel.o 0x10020" \
    -ex "break kmain" \
    -ex "set confirm on" \
    -ex 'c'