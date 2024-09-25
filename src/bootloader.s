bits 16

%include "boot.inc"

section .text

boot_sector_1_start:
	cli
	cld
	jmp 0x0000:fix_cs

fix_cs:
	mov byte[drive_number], dl

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

	; Reset the disk
	mov dl, byte[drive_number]
	mov ah, 0x00
	int 0x13

	; Read all the sectors of the first cylinder
	mov ah, 0x02
	mov al, SECTOR_PER_CYLINDER - 1
	mov cx, 2
	xor dh, dh
	mov dl, byte[drive_number]
	xor bx, bx
	mov es, bx
	mov ds, bx
	mov bx, BOOT_SECTOR(1)
	int 0x13

	; Jump at the start of the second sector to attempt to enable lineA20
	jmp boot_sector_2_start

PAD_SECTOR(SECTOR_SIZE - 14 - 1 - 2)

ArcadOSMark:
	db "Chirp chirp !", 0

drive_number:
	db 0

dw MAGIC_BOOT_NUMBER
