bits 32

%include "boot.inc"
%include "paging.inc"

section .text

paging_start:
	mov edi, BSS_32BIT_PROTECTED_ADDR + SYSTEM_PLM4T_ADDR
	mov cr3, edi
	xor eax, eax

	mov ecx, 4096
	mov edi, SYSTEM_PLM4T_ADDR
	rep stosd

	mov edi,  SYSTEM_PLM4T_ADDR
	mov dword[edi], BSS_32BIT_PROTECTED_ADDR + SYSTEM_PAGE_DIRECTORY_POINTER_ADDR | 0x03
	mov edi, SYSTEM_PAGE_DIRECTORY_POINTER_ADDR
	mov dword[edi], BSS_32BIT_PROTECTED_ADDR + SYSTEM_PAGE_DIRECTORY_ADDR | 0x03

	mov edi, SYSTEM_PAGE_DIRECTORY_ADDR
	mov ebx, BSS_32BIT_PROTECTED_ADDR + SYSTEM_PAGE_TABLE_ADDR | 0x03
	mov ecx, ALLOC_DIRECTORY_ENTRY_COUNT
.setDirectoryEntryLoop:
	mov dword[edi], ebx
	add ebx, 0x1000
	add edi, 8
	loop .setDirectoryEntryLoop

	mov edi, SYSTEM_PAGE_TABLE_ADDR + (SYSTEM_PAGE_SKIP * 8)
	mov ebx, SYSTEM_PAGE_ADDRESSING_START | 0x03 ;we can use physical memory address 0x00, we don't care about that
	mov ecx, PAGE_COUNT - (SYSTEM_PAGE_SKIP * 8)
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

	mov ax, 0x08 ;code segment in gdt 32 bits
	mov ds, ax

	movzx ecx, word[gdt64.ptr]
	mov esi, gdt64
	mov edi, GDT64_LOCATION
	inc ecx
	rep movsb

	movzx ecx, word[gdt64.ptr]

	mov ax, 0x18
	mov ds, ax

	mov word[GDTR64_LOCATION], cx
	mov dword[GDTR64_LOCATION + 2], BSS_32BIT_PROTECTED_ADDR + GDT64_LOCATION


	lgdt [GDTR64_LOCATION]

	jmp gdt64.code64:.setCS
bits 64
.setCS:
	mov ax, gdt64.data
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ax, gdt64.stack
	mov ss, ax

	mov eax, 0x0EFFFF0
	mov esp, eax

	jmp IDT_Setup
gdt64:
	.null: equ ($ - gdt64)
		dq GDT_ENTRY(0, 0, 0, 0)
	.code32: equ ($ - gdt64)
		dq GDT_ENTRY(0x00000000, 0x002FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, false)) ;CODE
	.code64: equ ($ - gdt64)
		dq GDT_ENTRY(0x00300000, 0x002FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, false, true)) ;CODE
	.screen: equ ($ - gdt64)
		dq GDT_ENTRY(0x000A0000, 320 * 200, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;SCREENDATA
	.data: equ ($ - gdt64)
		dq GDT_ENTRY(0x00800000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;DATA
	.rodata: equ ($ - gdt64)
		dq GDT_ENTRY(0x00A00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, false, false), GDT_FLAG(false, true, false)) ;RODATA
	.bss: equ ($ - gdt64)
		dq GDT_ENTRY(0x00C00000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;BSS
	.stack: equ ($ - gdt64)
		dq GDT_ENTRY(0x00E00000, 0x000FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;BSS
	.tss: equ ($ - gdt64)
		dq GDT_ENTRY(0x00F00000, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false)) ;TSS
	.ptr:
        dw $ - gdt64 - 1
        dq gdt64

PAD_SECTOR(SECTOR_SIZE)

;bits 64
;long_mode_test:
;	mov rcx, 640
;	mov rdi, 0xA0000
;	mov rax, 0x0D0D0D0D0D0D0D0D
;	rep stosq
;	jmp $
;
