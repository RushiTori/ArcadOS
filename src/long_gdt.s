bits 32

%include "LONG_GDT.inc"

ORG 0x00600000

load_long_gdt:
	


gdtr_long:
	dw gdt_long_end - gdt_long_start
	dq gdt_long_start


gdt_long_start:
	do LONG_GDT_ENTRY(0, 0, 0, 0)
	dq LONG_GDT_ENTRY(0x00000000, 0x007FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, true))	; code memory map
	dq LONG_GDT_ENTRY(0x00800000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, false, false), GDT_FLAG(false, true, true))	; rodata memory map
	dq LONG_GDT_ENTRY(0x00A00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, true))	; data memory map
	dq LONG_GDT_ENTRY(0x00C00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, true))	; bss memory map
	dq LONG_GDT_ENTRY(0x00E00000, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, true))	; TSS, now used only to avoid issues with GDT and loading


gdt_long_end:
