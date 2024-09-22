bits 32

;sector 4

%include "GDT.inc"
%include "paging.inc"
%include "boot.inc"

ORG BOOT_START_ADDR + (SECTOR_SIZE * 3)

paging_start:
	mov edi, PLM4T_ADDR
	mov cr3, edi
	xor eax, eax
	mov ecx, 4096
	rep stosd
	mov edi, cr3

	mov dword[edi], PAGE_DIRECTORY_POINTER_ADDR | 0x03
	add edi, 0x1000
	mov dword[edi], PAGE_DIRECTORY_ADDR | 0x03
	add edi, 0x1000
	mov dword[edi], PAGE_TABLE_ADDR | 0x03
	add edi, 0x1000

	mov ebx, 0x3
	mov ecx, 512
.setEntry:
	mov dword[edi], ebx
	add ebx, 0x1000
	add edi, 8
	loop .setEntry

	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax
	
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr

	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax

	lgdt [gdtr_long]

	jmp 0x8:(BOOT_START_ADDR + (SECTOR_SIZE * 4))

gdtr_long:
	dw gdt_long_end - gdt_long_start
	dd gdt_long_start

gdt_long_start:
	dq GDT_ENTRY(0, 0, 0, 0)
	dq GDT_ENTRY(0x00000000, 0x007FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, true))	; code memory map
	dq GDT_ENTRY(0x00800000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))	; data memory map
	dq GDT_ENTRY(0x00A00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, false, false), GDT_FLAG(false, true, false))	; rodata memory map
	dq GDT_ENTRY(0x00C00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false))	; bss memory map
	dq GDT_ENTRY(0x00E00000, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false))	; TSS, now used only to avoid issues with GDT and loading
gdt_long_end:

times 512 - ($ - $$) db 0

bits 64
long_mode_test:
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0x0D0D0D0D0D0D0D0D
	rep stosq
	jmp $
