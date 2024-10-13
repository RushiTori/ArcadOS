%ifndef MEMMAP_INC
%define MEMMAP_INC

;imma put the memory map there for now
%define BUF_ADDR 0x1002
%define BUF_LEN_ADDR BUF_ADDR - 2
%define MEM_ENTRY_SIZE 24

struc memmap_entry
	.base:						resq 1
	.length:					resq 1
	.memtype:					resd 1
	.acpi_extended_attributes:	resd 1
endstruc

extern memmap_start

%endif ;MEMMAP_INC
