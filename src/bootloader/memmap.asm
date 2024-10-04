bits 16

%include "bootloader/memmap.inc"


low_mem_size:
	dw 0

memmap_start:
global memmap_start:function
	;clc
	;int 0x12
	;jc .error
	;mov [low_mem_size], ax

	mov word[BUF_LEN_ADDR], 0
	xor ebx, ebx
	mov di, BUF_ADDR
	.readEntryLoop:
		clc
		mov eax, 0xE820
		mov ecx, 24
		mov edx, 0x534D4150
		int 0x15
		;jc .error
		inc word[BUF_LEN_ADDR]
		add di, MEM_ENTRY_SIZE
		cmp ebx, 0
		jne .readEntryLoop
	;call set_cursor_pos
	mov cx, [BUF_LEN_ADDR]
	mov si, BUF_ADDR
	.loop:
		cmp cx, 0
		je .endloop
		push cx
		push si
		call print_entry
		pop si
		pop cx
		add si, MEM_ENTRY_SIZE
		dec cx
		jmp .loop
	.endloop:
	cli
.error:
	jmp $

;si: entry index
print_entry:
	mov di, basestr
	call print_str
	mov di, hexprefix
	call print_str
	mov di, word[si + 6]
	call print_hex
	mov di, word[si + 4]
	call print_hex
	mov di, word[si + 2]
	call print_hex
	mov di, word[si]
	call print_hex

	mov di, lengthstr
	call print_str
	mov di, hexprefix
	call print_str
	mov di, word[si + 14]
	call print_hex
	mov di, word[si + 12]
	call print_hex
	mov di, word[si + 10]
	call print_hex
	mov di, word[si + 8]
	call print_hex
	
	mov di, typestr
	call print_str
	mov ax, [si + 16]
	cmp ax, 1
	jne .skipusablemem

	mov di, usablestr
	call print_str
	jmp .endswitch
.skipusablemem:

	cmp ax, 2
	jne .skipreservedmem

	mov di, reservedstr
	call print_str
	jmp .endswitch
.skipreservedmem:
	
	cmp ax, 3
	jne .skipACPIreclaimed

	mov di, acpireclaimedstr
	call print_str
	jmp .endswitch
.skipACPIreclaimed:
	
	cmp ax, 4
	jne .skipACPINVS

	mov di, acpinvsstr
	call print_str
	jmp .endswitch
.skipACPINVS:

	mov di, badmemorystr
	call print_str
.endswitch

	mov di, newlinestr
	call print_str
	ret

;dh: line
;dl: col
set_cursor_pos:
	mov ah, 0x02
	mov bh, 0
	int 0x10
	ret

print_str:
	push bp
	mov bp, sp
	push ax
	push bx
	.print_loop:
		mov al, byte[di]
		cmp al, 0
		je .end_print_loop

		mov ah, 0x0E
		xor bx, bx
		int 0x10

		inc di
		jmp .print_loop
	.end_print_loop:
	pop bx
	pop ax
	pop bp
	ret

;di: value
print_hex:
	push bp
	mov bp, sp
	mov bx, sp
	mov byte[bx], 0
	dec sp
	mov ax, di
	mov cx, 4
	.divloop:
		xor dx, dx
		mov bx, 16
		div bx
		cmp dl, 10
		jl .decimalHandling
		add dl, ('A' - 10)
		jmp .save
	.decimalHandling:
		add dl, '0'
	.save:
		mov bx, sp
		mov [bx], dl
		dec sp
		loop .divloop
	mov di, sp
	inc di
	call print_str
	mov sp, bp
	pop bp
	ret

basestr:
	db "base: ", 0
lengthstr:
	db ", length: ", 0
typestr:
	db ", type: ", 0
ACPIstr:
	db ", ACPI: ", 0
newlinestr:
	db 0xA, 0xD, 0

usablestr:
	db "usable", 0
reservedstr:
	db "reserved", 0
acpireclaimedstr:
	db "ACPI reclaimed", 0
acpinvsstr:
	db "ACPI NVS", 0
badmemorystr:
	db "bad memory", 0

hexprefix:
	db "0x", 0
