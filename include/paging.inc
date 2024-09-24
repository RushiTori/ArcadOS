%ifndef PAGING_INC
%define PAGING_INC

%define PAGE_TABLE_SIZE						0x00001000
%define PAGE_TABLE_ENTRY_COUNT				PAGE_TABLE_SIZE / 8
%define PAGE_DIRECTORY_SIZE					0x00001000
%define PAGE_DIRECTORY_ENTRY_COUNT			PAGE_DIRECTORY_SIZE / 8
%define PAGE_DIRECTORY_POINTER_SIZE			0x00001000
%define PAGE_DIRECTORY_POINTER_ENTRY_COUNT	PAGE_DIRECTORY_POINTER_SIZE / 8
%define PAGE_PLM4T_SIZE						0x00001000
%define PAGE_PLM4T_ENTRY_COUNT				PAGE_PLM4T_SIZE / 8

%define SYSTEM_PLM4T_ADDR					0x00001000 ;index of start of PLM4T
%define SYSTEM_PAGE_DIRECTORY_POINTER_ADDR	0x00002000 ;index of start of the page directory pointer
%define SYSTEM_PAGE_DIRECTORY_ADDR			0x00003000 ;index of start of the page directory
%define SYSTEM_PAGE_TABLE_ADDR				0x00004000 ;index of the start of page tables

%define SYSTEM_PAGE_ADDRESSING_START		0x00001000						;first addressable memory
%define PAGE_COUNT							PAGE_TABLE_SIZE * 65			;number of page table entries to set
%define DIRECTORY_ENTRY_COUNT				PAGE_COUNT / PAGE_TABLE_SIZE	;number of page directory entries to set

%endif ;PAGING_INC
