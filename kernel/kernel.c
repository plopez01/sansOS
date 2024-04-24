#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "include/multiboot.h"

bool isNumAligned(int num) {
    return (num & 0b111) == 0;
}

int alignNum(int num){
    if (isNumAligned(num)) return num;
    else return num - (num & 0b111) + 8;
}

void kernel_main(multiboot_uint32_t* multiboot){
	register int eax asm("eax");
  // Indexed color
	/*if (multiboot->framebuffer_type == 0){
		unsigned char* palette = (unsigned char*)multiboot->framebuffer_palette_addr;
		*palette = 0xFF;
		*(palette+1) = 0x0;
		*(palette+2) = 0x0;

		*((uint64_t*) multiboot->framebuffer_addr) = 1;
		*((uint64_t*) multiboot->framebuffer_addr + 100*multiboot->framebuffer_pitch + 100) = 0;
	} else if (multiboot->framebuffer_type == 1) {

	} else {
		// Unsupported EGA text mode
		// TODO: Print message saying so
	  *((uint64_t*)0xB8000) = 'j'*16 + 0x0f;
  }*/

  multiboot_uint32_t total_size = *multiboot;
  int size = 2;
  multiboot_uint32_t* tag_selector = multiboot + size;
  
  for (int i = 0; i < 20; i++) {
    // Tag header
    struct multiboot_tag* tag_header = (struct multiboot_tag*)tag_selector;

    *((int*)0) = tag_header->type;
    *((int*)4) = tag_header->size; 
    *((int*)8) = tag_selector - multiboot;
    // Calculate next tag address
    tag_selector += alignNum(tag_header->size)/sizeof(multiboot_uint32_t); 
    eax = tag_header->type;
    if  (tag_header->type == 8) break;
  }

  *((short*)753664) = 0x0f00 + 'j';
}
