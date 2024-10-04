%ifndef PAGING_INC
%define PAGING_INC

%define PAGE_SIZE							0x00001000

%define PAGE_TABLE_ENTRY_COUNT				512
%define PAGE_DIRECTORY_ENTRY_COUNT			512
%define PAGE_DIRECTORY_POINTER_ENTRY_COUNT	512
%define PAGE_PLM4T_ENTRY_COUNT				512

%define BSS_32BIT_PROTECTED_ADDR			0x00800000 ;physical address that serves as base for the offsets described under
%define SYSTEM_PLM4T_ADDR					0x00002000 ;index of start of PLM4T 0x802000 - 0x802FFF
%define SYSTEM_PAGE_DIRECTORY_POINTER_ADDR	0x00003000 ;index of start of the page directory pointer 0x803000 - 0x803FFF
%define SYSTEM_PAGE_DIRECTORY_ADDR			0x00004000 ;index of start of the page directory 0x804000 - 0x804FFF
%define SYSTEM_PAGE_TABLE_ADDR				0x00005000 ;index of the start of page tables 0x805000 - 0x805FFF
;so memory from 0x800000 to 0x805FFF shall not be touched, might change the range if we page allocate more memory

%define SYSTEM_PAGE_ADDRESSING_START		0x00001000						;first addressable memory
%define SYSTEM_PAGE_SKIP					(SYSTEM_PAGE_ADDRESSING_START / PAGE_SIZE) ;number of page table entries to skip in order to keep the memory addressing start correct
%define PAGE_COUNT							PAGE_TABLE_ENTRY_COUNT * 64			;number of page table entries to set
%define ALLOC_DIRECTORY_ENTRY_COUNT			PAGE_COUNT / PAGE_TABLE_ENTRY_COUNT	;number of page directory entries to set

%define GDTR64_LOCATION						0x00001000
%define GDT64_LOCATION						GDTR64_LOCATION + 10 ;in segment data

%define OLD_SCREEN_MEM_ADDR					0xA0000
%define NEW_SCREEN_MEM_ADDR					0x4000000

%endif ;PAGING_INC
