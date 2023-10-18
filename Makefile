.PHONY: all qemu clean

all : sansos.iso
qemu : sansos.iso
	qemu-system-i386 -cdrom sansos.iso
usb : sansos.iso
	sudo dd if=sansos.iso of=/dev/sda && sync
clean:
	rm boot.o kernel.o sansos.bin sansos.iso

boot.o : arch/i386/boot.S
	nasm -f elf32 $< -o $@

kernel.o : kernel/kernel.c
	i686-elf-gcc -c $< -o $@ -ffreestanding -O2 -Wall -Wextra -std=gnu99

sansos.bin : kernel.o boot.o linker.ld
	i686-elf-gcc -T linker.ld -o $@ -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

sansos.iso : sansos.bin grub.cfg
	mkdir -p isodir/boot/grub
	cp sansos.bin isodir/boot
	cp grub.cfg isodir/boot/grub
	grub-mkrescue -o $@ isodir


