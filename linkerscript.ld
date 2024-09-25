ENTRY(boot_sector_1_start)

SECTIONS
{

. = 0x7C00;

.text : { *(.text) }

. = 0x10000;
.rodata : { *(.rodata) }

. = 0x20000;
.data : { *(.data) }

. = 0x30000;
.bss : { *(.bss) }

}
