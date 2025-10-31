bits 16

%include "bootloader/boot.inc"
%include "bootloader/pic.inc"

section .text

boot_sector_3_start:
	; change the vga mode to 320x200 8bpp graphics
	mov ax, 0x0013
	int 0x10

	mov ax, 0
	mov ds, ax
	mov es, ax

	; load the 32bits gdt and enable protected mode
	lgdt [gdt32.ptr]
	
	mov eax, cr0
	or al, true ; bit 0 is protected mode enabling
	mov cr0, eax
	cli ;disabling interrupts before the cpu shits the bed

	; now we can jump to 32bits code
	jmp gdt32.code32:prepare_segment_registers32

bits 32

prepare_segment_registers32:
	
	mov ax, gdt32.bss
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov esp, 0x00020000
	mov ebp, 0x00020000

	mov edi, 0x20
	mov esi, 0x30
	call remap_pic32

	jmp make_idt_32

gdt32:
	.null: equ ($ - gdt32)
		dq GDT_ENTRY(0, 0, 0, 0)
	.code32: equ ($ - gdt32)
		dq GDT_ENTRY(0x00000, 0xFFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, false))
	.bss: equ ($ - gdt32)
		dq GDT_ENTRY(0x00000, 0xFFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))
	;.tss: equ ($ - gdt32)	
	;	dq GDT_ENTRY(0x00007C00, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false))
	.ptr:
        dw $ - gdt32 - 1
        dq gdt32

