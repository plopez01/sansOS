MB_MAGIC equ 0xE85250D6
ARCH equ 0
HEADER_LENGTH equ header_end - header_start

CHECKSUM equ 0x100000000 - (MB_MAGIC + ARCH + HEADER_LENGTH)


section .multiboot
header_start:
align 4
	dd MB_MAGIC
	dd ARCH
	dd header_end - header_start
	dd CHECKSUM

	dw 6
	dw 0
	dd 8

	dw 0
	dw 0 
	dd 0
header_end:

section .bss
align 16
stack_bottom:
resb 16384 ; 16k stack
stack_top:

; 32-bit protected mode, no interrupts, no paging, no extensions or FP operations.
section .text
global _start:function ; We pass ELF extension symbol type and size
_start:
	mov esp, stack_top
	
	push ebx ; Push multiboot info struct to stack for the kernel to read
	extern kernel_main
	call kernel_main

	cli
.hang: hlt
	jmp .hang
.end:

