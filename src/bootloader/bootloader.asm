bits 16

%include "bootloader/boot.inc"
%include "bootloader/memmap.inc"

section .text

boot_sector_1_start:
;BPB
bpb:
	jmp .end
	db "EXFAT   "
	times 53 db 0
.end:


	cli
	cld
	jmp 0x0000:fix_cs

fix_cs:

	; Init segment registers at zero
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Init stack frame at BOOT_SECTOR(0)
	mov sp, BOOT_SECTOR(0)
	mov bp, BOOT_SECTOR(0)

	mov byte[drive_number], dl
	
	; Reset the disk
	mov dl, byte[drive_number]
	mov ah, 0x00
	int 0x13

	jnc .skipResetFault
	mov di, ResetFailMessage
	call print_str
	jmp $
.skipResetFault:

	; Read all the sectors of the first cylinder
	mov ah, 0x02
	mov al, SECTOR_PER_CYLINDER - 1
	mov cx, 2
	mov dh, 0
	mov dl, byte[drive_number]
	xor bx, bx
	mov ds, bx
	mov es, bx
	mov bx, BOOT_SECTOR(1)
	int 0x13

	;LBA method
	;mov ah, 0x42
	;mov dl, byte[drive_number]
	;xor bx, bx
	;mov ds, bx
	;mov si, DAP
	;int 0x13


	jnc .skipReadFault
	mov di, ReadFailMessage
	call print_str
	mov ch, ah
	call print_int
	jmp $
.skipReadFault:

	; Jump at the start of the second sector to attempt to enable lineA20
	jmp memmap_start ; memmap_start

print_str:
	push bp
	mov bp, sp
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
	pop bp
	ret

;ch = number to print
print_int:
	push bp
	mov bp, sp
	push bx
	cmp ch, 0
	.convLoop:
		mov al, ch
		and al, 0xF
		cmp al, 0xA
		jge .handleHex
		add al, '0'
		
		jmp .printChar

	.handleHex:
		add al, ('A' - 10)
	.printChar:
		mov ah, 0x0E
		mov bh, 0
		mov bl, 0
		int 0x10
		shr ch, 4
		jne .convLoop
	.end_print_loop:
	pop bx
	pop bp
	ret

;DAP:
;	db 0x10		;DAP size (always 0x10)
;	db 0			;unused

;	dw 0x40		;number of sectors to read

;	dw 0x7E00
;	dw 0x0

;	dd 1           ;LBA address of the first sector to read (0 indexed)
;	dd 0		   ;more bytes, only for lbas bigger than 4 bytes


ResetFailMessage:
	db "drive resetting has failed", 0xA, 0xD, 0
ReadFailMessage:
	db "drive reading has failed", 0xA, 0xD, 0

PAD_SECTOR(SECTOR_SIZE - 14 - 1 - 2)

ArcadOSMark:
	db "Chirp chirp !", 0

drive_number:
	db 0

dw MAGIC_BOOT_NUMBER
