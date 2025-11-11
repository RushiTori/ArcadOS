ENTRY(boot_sector_1_start)

SECTIONS
{

. = 0x7C00;

.text : { *(.text) }

. = 0x100000;
.data : { *(.data) }

. = 0x200000;
.bss : { *(.bss) }

. = 0x300000;
.rodata : { *(.rodata) }


}
