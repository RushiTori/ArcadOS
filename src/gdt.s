bits 16

%include "GDT.inc"

org BOOT_START_ADDR + (SECTOR_SIZE * 2)

boot_sector_3_start:
	mov ax, 0x0013

	int 0x10

	lgdt [gdtr]
	
	mov eax, cr0
	or al, true ; bit 0 is protected mode enabling
	mov cr0, eax

	jmp 0x08:protected ; 0x08 is the value to boot in kernel privilege with the GDT table, index 1, which is code memory

gdtr:
	dw gdt_end - gdt
	dd gdt

gdt:
	dq GDT_ENTRY(0, 0, 0, 0)
	dq GDT_ENTRY(0x00000000, 0x007FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, false))		; code memory map
	dq GDT_ENTRY(0x00800000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, false, false), GDT_FLAG(false, true, false))	; rodata memory map
	dq GDT_ENTRY(0x00A00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))		; data memory map
	dq GDT_ENTRY(0x00C00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))		; bss memory map
	dq GDT_ENTRY(0x00007C00, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false))									; TSS, now used only to avoid issues with GDT and loading
	
	;dw 0xFFFF
	;dw 0x0000
	;db 0x00
	;db 0x9A
	;db 0xC0
	;db 0x00

	;dw 0xFFFF
	;dw 0x0000
	;db 0x80
	;db 0x92
	;db 0xC0
	;db 0x00

	;dw 0x40 * 0x0200
	;dw 0x7C00
	;db 0x00
	;db 0x8B
	;db 0x00
	;db 0x00
gdt_end:

times (512 - ($ - $$)) db 0

bits 32
hello_protected_string:
	db "hello protected mode!", 0
protected:
	mov edi, 0xA0001
	.loopone:
		mov al, 0x3C
		mov byte[edi], al
		inc edi
		cmp edi, 0xA0000 + 8 * 8 ;+ (320 * 200) - 1
		jne .loopone
	jmp $

	mov esi, hello_protected_string
	mov ecx, 0
	.loop:
		lodsb
		cmp al, 0
		je .end
		mov byte[0xB8000 + ecx * 2], al
		mov byte[0xB8000 + ecx * 2 + 1], 0x8D
		inc ecx
		jmp .loop
	.end:

	jmp $
