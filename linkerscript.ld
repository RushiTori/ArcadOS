ENTRY(boot_sector_1_start)

SECTIONS
{

. = 0x7C00;

.text : { *(.text) }

. = 0x1000000;
.data : { *(.data) }

. = 0x2000000;
.bss : { *(.bss) }

. = 0x3000000;
.rodata : { *(.rodata) }


}
