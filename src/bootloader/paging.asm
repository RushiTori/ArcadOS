bits 32

%include "bootloader/boot.inc"
%include "bootloader/paging.inc"
%include "bootloader/memmap.inc"

section .text

paging_start:

	

;	mov ah, 0x3C
;	mov edi, 0xA0000
	
;.copyLoop:
;	mov byte[edi], ah
;	inc edi
;	cmp edi, 0xAFFFF
;	jne .copyLoop

	xor eax, eax
	mov ecx, SYSTEM_PAGE_STRUCT_SIZE
	mov edi, SYSTEM_PLM4T_ADDR
	rep stosd
	;clear PLM4T

	mov edi,  SYSTEM_PLM4T_ADDR
	mov dword[edi], SYSTEM_PAGE_DIRECTORY_POINTER_ADDR | 0x03 ;we need the first PLM4T entry to point to our only PDP

	xor eax, eax
	mov ecx, SYSTEM_PAGE_STRUCT_SIZE
	mov edi, SYSTEM_PAGE_DIRECTORY_POINTER_ADDR ;our PDP memory
	rep stosd

	mov edi, SYSTEM_PAGE_DIRECTORY_POINTER_ADDR
	mov dword[edi], SYSTEM_PAGE_DIRECTORY_ADDR | 0x03  ;now we set the PDP's first entry to point to our only PD

	xor eax, eax
	mov ecx, SYSTEM_PAGE_STRUCT_SIZE
	mov edi, SYSTEM_PAGE_DIRECTORY_ADDR ;our PD memory
	rep stosd

	mov edi, SYSTEM_PAGE_DIRECTORY_ADDR
	mov ebx, SYSTEM_PAGE_TABLE_ADDR | 0x03 ;now we allocate for as many directory entries as we need
	mov ecx, ALLOC_DIRECTORY_ENTRY_COUNT
.setDirectoryEntryLoop:
	mov dword[edi], ebx
	add ebx, PAGE_SIZE
	add edi, 8
	loop .setDirectoryEntryLoop

	xor eax, eax
	mov ecx, PAGE_TABLE_ENTRY_COUNT ;number of page tables
	mov edi, SYSTEM_PAGE_TABLE_ADDR ;clear page tables
	rep stosd


	mov edi, SYSTEM_PAGE_TABLE_ADDR + 8
	mov ebx, SYSTEM_PAGE_ADDRESSING_START | 0x03
	mov ecx, PAGE_COUNT
.setTableEntryLoop:
	mov dword[edi], ebx
	add ebx, PAGE_SIZE
	add edi, 4
	mov dword[edi], 0
	add edi, 4
	loop .setTableEntryLoop

	;infinite loop
	;mov edi, SYSTEM_PAGE_TABLE_ADDR + (SYSTEM_PAGE_SKIP * 8)
	;mov ebx, SYSTEM_PAGE_ADDRESSING_START | 0x03 ;we can use physical memory address 0x00, we don't care about that
	;mov ecx, PAGE_COUNT - (SYSTEM_PAGE_SKIP * 8)
;.setEntry:
;	mov dword[edi], ebx
;	add ebx, PAGE_SIZE
;	add edi, 8
;	loop .setEntry

	;mov esi, SYSTEM_PAGE_TABLE_ADDR + ((SYSTEM_PAGE_SKIP) / PAGE_SIZE) * 8
	;mov edi, -24
	;mov ecx, TOTAL_PAGES_REQUIRED
	;.allocatePagesLoop:
	;	add edi, 24

	;	push ds
	;	mov ax, 0x28
	;	mov ds, ax

	;	xor eax, eax
	;	mov ax, word[SYSTEM_MEMORY_MAP_LEN]
	;	cmp eax, edi
	;	je .error

	;	call get_mem_section_page_count
	;	cmp eax, 0
	;	je .allocatePagesLoop

	;	sub ecx, eax
	;	push ecx
	;	mov ecx, eax

	;	mov ebx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.base]
	;	and ebx, 0xfff
	;	mov ebx, [SYSTEM_MEMORY_MAP + edi + memmap_entry.base]
	;	jz .skipalignAddress
	;		and ebx, ~(0xFFF)
	;		add ebx, 0x1000
	;	.skipalignAddress:
	;	push edi
	;	mov edi, esi
	;	pop ds

	;	.setPagesLoop:
	;		cmp edi, (SYSTEM_PAGE_TABLE_ADDR + ((0x4000000 / 0x1000) * 8))
	;		jne .skipHandleScreenMemory
	;			push ebx
	;			mov ebx, 0xA0000
	;		.skipHandleScreenMemory:

	;		mov [SYSTEM_PAGE_TABLE_ADDR + edi], ebx
	;		
	;		cmp ebx, 0xA0000
	;		jne .skipRestorePhysicalAddress
	;			cmp edi, (SYSTEM_PAGE_TABLE_ADDR + ((0xA0000 / 0x1000) * 8))
	;			je .skipRestorePhysicalAddress
	;			pop ebx
	;		.skipRestorePhysicalAddress:

	;		add ebx, 0x1000
	;		add edi, 8
	;		loop .setPagesLoop
	;	pop edi
	;	pop ecx
	;	cmp ecx, 0
	;	ja .allocatePagesLoop


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

	;enable PAE
	mov edx, cr4
	or edx, 1 << 5
	mov cr4, edx
	
	;set LME
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr

	mov eax, SYSTEM_PLM4T_ADDR
	mov cr3, eax

	;enable paging
	mov ebx, cr0
	or ebx, (1 << 31) | (1 << 0)
	mov cr0, ebx ;crashes here (page for 0x1000 is dirty and accessed)

	lgdt [gdtr64]

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
	mov ss, ax

	mov eax, 0x0EFFFF0
	mov esp, eax

	mov al, 'C'
	mov ah, 0x07
	mov [0xB8000], al
	mov [0xB8001], ah

	mov al, 'h'
	mov ah, 0x07
	mov [0xB8002], al
	mov [0xB8003], ah

	mov al, 'i'
	mov ah, 0x07
	mov [0xB8004], al
	mov [0xB8005], ah

	mov al, 'r'
	mov ah, 0x07
	mov [0xB8006], al
	mov [0xB8007], ah

	mov al, 'p'
	mov ah, 0x07
	mov [0xB8008], al
	mov [0xB8009], ah

	jmp make_idt_64
	;jmp IDT_Setup
gdt64:
	.null: equ ($ - gdt64)
		dq GDT_ENTRY(0, 0, 0, 0)
	.code32: equ ($ - gdt64)
		dq GDT_ENTRY(0x00000000, 0x0009FFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, true, false)) ;CODE
	.code64: equ ($ - gdt64)
		dq GDT_ENTRY(0x00000000, 0x002FFFFF, ARCADOS_ACCESS_BYTE(true, true, false, true, false), GDT_FLAG(false, false, true)) ;CODE
	;.screen: equ ($ - gdt64)
	;	dq GDT_ENTRY(0x000A0000, 320 * 200, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;SCREENDATA
	.data: equ ($ - gdt64)
		dq GDT_ENTRY(0x00000000, 0x001FFFFF, ARCADOS_ACCESS_BYTE(true, false, false, true, false), GDT_FLAG(false, true, false)) ;DATA
	.tss: equ ($ - gdt64)
		dq GDT_ENTRY(0x00F00000, 0x0000FFFF, ARCADOS_ACCESS_BYTE(false, true, false, false, true), GDT_FLAG(false, false, false)) ;TSS
	.ptr:
        dw $ - gdt64 - 1
        dq gdt64
.end:

gdtr64:
	.size:
		dw gdt64.end - gdt64
	.ptr:
		dq gdt64
.end:

;bits 64
;long_mode_test:
;	mov rcx, 640
;	mov rdi, 0xA0000
;	mov rax, 0x0D0D0D0D0D0D0D0D
;	rep stosq
;	jmp $
;
