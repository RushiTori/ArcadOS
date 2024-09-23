bits 16

%include "boot.inc"

org BOOT_SECTOR(2)

boot_sector_3_start:
	; change the vga mode to 320x200 8bpp graphics
	mov ax, 0x0013
	int 0x10

	; load the 32bits gdt and enable protected mode
	lgdt [gdt32.ptr]
	mov eax, cr0
	or al, true ; bit 0 is protected mode enabling
	mov cr0, eax

	; now we can jump to 32bits code
	jmp gdt32.code32:BOOT_SECTOR(3)

gdt32:
	.null: equ ($ - gdt32)
		dq GDT_ENTRY(0, 0, 0, 0)
	.code32: equ ($ - gdt32)
		dq GDT_ENTRY(0x00000000, 0x007FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, false))
	.code16: equ ($ - gdt32)
		dq GDT_ENTRY(0x00600000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, false, false))
	.bss: equ ($ - gdt32)
		dq GDT_ENTRY(0x00800000, 0x00FFFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))
	.tss: equ ($ - gdt32)
		dq GDT_ENTRY(0x00007C00, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false))
	.ptr:
        dw $ - gdt32 - 1
        dq gdt32

PAD_SECTOR(SECTOR_SIZE)
