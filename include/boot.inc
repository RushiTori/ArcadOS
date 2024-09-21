%ifndef BOOT_INC
%define BOOT_INC

%include "BIOS.inc"

%define SECTOR_SIZE         0x0200
%define SECTOR_PER_CYLINDER 0x0040
%define BOOT_START_ADDR     0x7C00

%endif ; BOOT_INC
