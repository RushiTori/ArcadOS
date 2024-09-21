%ifndef BIOS_INC
%define BIOS_INC

%define INT_VIDEO_SERVICES         0x10
%define VIDEO_SERVICE_PUT_CHAR     0x0E

%define INT_DRIVE_SERVICES         0x13
%define DRIVE_SERVICE_RESET_DISK   0x00
%define DRIVE_SERVICE_READ_SECTORS 0x02

%macro bios_putchar 2
	mov ah, VIDEO_SERVICE_PUT_CHAR
	mov al, %1
	xor bx, bx
	mov bl, %2
	int INT_VIDEO_SERVICES
%endmacro

%endif ; BIOS_INC
