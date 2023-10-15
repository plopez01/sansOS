#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined (__linux__)
#error "Please use a cross complier to compile sansOS"
#endif

#if !defined (__i386__)
#error "You need a ix386-elf cross compiler to compile sansOS"
#endif


void kernel_main(void) {

}
