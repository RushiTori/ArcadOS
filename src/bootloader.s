bits 16

%include "boot.inc"

org BOOT_START_ADDR

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

	; Init stack frame at BOOT_START_ADDR
	mov sp, BOOT_START_ADDR
	mov bp, BOOT_START_ADDR

	; Reset the disk
	mov dl, byte[drive_number]
	mov ah, DRIVE_SERVICE_RESET_DISK
	int INT_DRIVE_SERVICES

	; Read all the sectors on the first cylinder
	mov ah, DRIVE_SERVICE_READ_SECTORS
	mov al, 1;SECTOR_PER_CYLINDER - 1
	mov cx, 2
	xor dh, dh
	mov dl, byte[drive_number]
	xor bx, bx
	mov es, bx
	mov ds, bx
	mov bx, BOOT_START_ADDR + SECTOR_SIZE
	int INT_DRIVE_SERVICES

	; Jump at the start of the second cylinder to attempt to enable
	jmp BOOT_START_ADDR + SECTOR_SIZE


times (495 - ($ - $$)) db 0

ArcadOSMark:
	db "Chirp chirp !", 0

drive_number:
	db 0

dw 0xAA55
