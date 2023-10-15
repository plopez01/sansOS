; Multiboot 1 header (migration to Multiboot 2 is pendant)
MB_ALIGN equ 1 << 0
MEMINFO equ 1 << 1
MB_FLAGS equ MB_ALIGN | MEMINFO

MB_MAGIC equ 0x1BADB002 ; Multiboot 1 magic value
CHECKSUM equ -(MB_MAGIC + MB_FLAGS)

section .multiboot
align 4
	dd MB_MAGIC
	dd MB_FLAGS
	dd CHECKSUM


section .bss
align 16
stack_bottom:
resb 16384 ; 16k stack
stack_top:

; 32-bit protected mode, no interrupts, no paging, no extensions or FP operations.
section .text
global _start:function(_start.end - _start) ; We pass ELF extension symbol type and size
_start:
	mov esp, stack_top

	extern kernel_main
	call kernel_main

	cli
.hang: hlt
	jmp .hang
.end:


