bits 16

%include "GDT.inc"

org BOOT_START_ADDR + (SECTOR_SIZE * 2)

boot_sector_3_start:
	jmp $

gdt:
	dq GDT_ENTRY(0, 0, 0, 0)
	dq GDT_ENTRY(0x00400000, 0x003FFFFF, 0x9A, 0xC)

times (512 - ($ - $$)) db 0
