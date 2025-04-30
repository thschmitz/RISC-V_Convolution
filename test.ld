OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
  PROVIDE(__stack_size = 0x4000);  /* 16 KB */

  . = 0x0;

  .text : {
    KEEP(*(.init))
    *(.text .text.*)
    KEEP(*(.fini))
  }

  .rodata : {
    *(.rodata .rodata.*)
  }

  .data : {
    *(.data .data.*)
  }

  .sdata : {
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.sdata .sdata.*)
  }

  .bss : {
    __bss_start = .;
    *(.sbss .sbss.*)
    *(.bss .bss.*)
    *(COMMON)
    _end = .;
  }

  .stack : {
    . = ALIGN(16);
    stack_start = .;
    . += __stack_size;
    stack_end = .;
  }
}

