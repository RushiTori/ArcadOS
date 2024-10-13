bits 32

%include "bootloader/boot.inc"
%include "bootloader/paging.inc"
%include "bootloader/memmap.inc"

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
	add ebx, PAGE_SIZE
	add edi, 8
	loop .setDirectoryEntryLoop

	;mov edi, SYSTEM_PAGE_TABLE_ADDR + (SYSTEM_PAGE_SKIP * 8)
	;mov ebx, SYSTEM_PAGE_ADDRESSING_START | 0x03 ;we can use physical memory address 0x00, we don't care about that
	;mov ecx, PAGE_COUNT - (SYSTEM_PAGE_SKIP * 8)
;.setEntry:
;	mov dword[edi], ebx
;	add ebx, PAGE_SIZE
;	add edi, 8
;	loop .setEntry

	mov esi, SYSTEM_PAGE_TABLE_ADDR + ((SYSTEM_PAGE_SKIP) / PAGE_SIZE) * 8
	mov edi, -24
	mov ecx, TOTAL_PAGES_REQUIRED
	.allocatePagesLoop:
		add edi, 24

		push ds
		mov ax, 0x28
		mov ds, ax

		xor eax, eax
		mov ax, word[SYSTEM_MEMORY_MAP_LEN]
		cmp eax, edi
		je .error

		call get_mem_section_page_count
		cmp eax, 0
		je .allocatePagesLoop

		sub ecx, eax
		push ecx
		mov ecx, eax

		mov ebx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.base]
		and ebx, 0xfff
		mov ebx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.base]
		jz .skipalignAddress
			and ebx, ~(0xFFF)
			add ebx, 0x1000
		.skipalignAddress:
		push edi
		mov edi, esi
		pop ds

		.setPagesLoop:
			cmp edi, (SYSTEM_PAGE_TABLE_ADDR + ((0x4000000 / 0x1000) * 8))
			jne .skipHandleScreenMemory
				push ebx
				mov ebx, 0xA0000
			.skipHandleScreenMemory:

			mov [SYSTEM_PAGE_TABLE_ADDR + edi], ebx
			
			cmp ebx, 0xA0000
			jne .skipRestorePhysicalAddress
				cmp edi, (SYSTEM_PAGE_TABLE_ADDR + ((0xA0000 / 0x1000) * 8))
				je .skipRestorePhysicalAddress
				pop ebx
			.skipRestorePhysicalAddress:

			add ebx, 0x1000
			add edi, 8
			loop .setPagesLoop
		pop edi
		pop ecx
		cmp ecx, 0
		ja .allocatePagesLoop


	;mov edi, SYSTEM_PAGE_TABLE_ADDR + (OLD_SCREEN_MEM_ADDR / PAGE_SIZE) * 8
	;mov ebx, NEW_SCREEN_MEM_ADDR | 0x03
	;mov ecx, 16
;.remapScreenMemory:
	;mov dword[edi], ebx
	;add ebx, PAGE_SIZE
	;add edi, 8
	;loop .remapScreenMemory

	;mov edi, SYSTEM_PAGE_TABLE_ADDR + (NEW_SCREEN_MEM_ADDR / PAGE_SIZE) * 8
	;mov ebx, OLD_SCREEN_MEM_ADDR | 0x3
	;mov ecx, 16
;.remapNewScreenMemory:
	;mov dword[edi], ebx
	;add ebx, PAGE_SIZE
	;add edi, 8
	;loop .remapNewScreenMemory

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

	jmp gdt64.code64:setCS
.error:
	hlt
	jmp .error
;edi: index of the memory block
;accesses the memory map stored at 0x1000
;mem_index_to_physical_address:
;	push ds
;
;	mov ecx, -1
;	mov ax, 0x28 ;memmap segment
;	mov ds, ax
;	.lookuploop:
;		inc ecx
;		cmp ecx, [SYSTEM_MEMORY_MAP_LEN]
;		jae .error
;		mov eax, [SYSTEM_MEMORY_MAP + memmap_entry.memtype + (ecx * memmap_entry_size)]
;		cmp eax, 1
;		jne .lookuploop
;		mov eax, [SYSTEM_MEMORY_MAP + memmap_entry.length]
;		cmp eax, 0x1000
;		jb .lookuploop
;		mov eax, [SYSTEM_MEMORY_MAP + memmap_entry.length]
;		xor edx, edx
;		mov esi, 0x1000
;		div esi
;		mov esi, eax
;		mov eax, [SYSTEM_MEMORY_MAP + memmap_entry.base]
;		and eax, 0xfff
;		mov eax, [SYSTEM_MEMORY_MAP + memmap_entry.base]
;		jz .skipAlign:
;			and eax, ~(0xfff)
;			add eax, 0x1000
;			dec esi
;		.skipAlign:
;			cmp edi, esi
;			jae .lookuploop

;rdi: memmap offset
;returns: rax: page count for the given entry, if the entry doesn't start at a page aligned base, it will count the base, up to the next page alignment, as an invalid page boundary, and as such, will give one less, you need to align your base by force to actually allocate it
get_mem_section_page_count:
	push ds

	mov ax, 0x28 ;memmap segment
	mov ds, ax

	mov eax, [SYSTEM_MEMORY_MAP + edi + memmap_entry.memtype]
	cmp eax, 1
	jne .error

	mov eax, [SYSTEM_MEMORY_MAP + edi + memmap_entry.length]
	mov edx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.length + 4]
	mov ecx, 0x1000
	div ecx
	mov edx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.base]
	and edx, 0x1000
	jnz .forceAlign
	cmp dword[SYSTEM_MEMORY_MAP + edi + memmap_entry.base], 0x1000
	jae .end
	cmp dword[SYSTEM_MEMORY_MAP + edi + memmap_entry.base + 4], 0
	jne .end
	.forceAlign:
		dec eax
	.error:
		mov eax, 0
	.end:
	pop ds
	ret

bits 64
setCS:
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

PAD_SECTOR(SECTOR_SIZE * 2)

;bits 64
;long_mode_test:
;	mov rcx, 640
;	mov rdi, 0xA0000
;	mov rax, 0x0D0D0D0D0D0D0D0D
;	rep stosq
;	jmp $
;
