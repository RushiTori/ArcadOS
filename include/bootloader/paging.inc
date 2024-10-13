%ifndef PAGING_INC
%define PAGING_INC

%define PAGE_SIZE							0x00001000

%define PAGE_TABLE_ENTRY_COUNT				512
%define PAGE_DIRECTORY_ENTRY_COUNT			512
%define PAGE_DIRECTORY_POINTER_ENTRY_COUNT	512
%define PAGE_PLM4T_ENTRY_COUNT				512

%define BSS_32BIT_PROTECTED_ADDR			0x00800000 ;physical address that serves as base for the offsets described under
%define SYSTEM_PLM4T_ADDR					0x00020000 ;index of start of PLM4T 0x020000 - 0x020FFF
%define SYSTEM_PAGE_DIRECTORY_POINTER_ADDR	0x00021000 ;index of start of the page directory pointer 0x21000 - 0x21FFF
%define SYSTEM_PAGE_DIRECTORY_ADDR			0x00022000 ;index of start of the page directory 0x22000 - 0x22FFF
%define SYSTEM_PAGE_TABLE_ADDR				0x00023000 ;index of the start of page tables 0x23000 - 0x24FFF
;so memory from 0x20000 to 0x25000 shall not be touched, might change the range if we page allocate more memory

%define SYSTEM_MEMORY_MAP_LEN				0x00000000
%define SYSTEM_MEMORY_MAP					0x00000002						;where the memory map is physically in memory

%define SYSTEM_PAGE_ADDRESSING_START		0x00001000						;first addressable memory
%define SYSTEM_PAGE_SKIP					(SYSTEM_PAGE_ADDRESSING_START / PAGE_SIZE) ;number of page table entries to skip in order to keep the memory addressing start correct
%define PAGE_COUNT							PAGE_TABLE_ENTRY_COUNT * 64			;number of page table entries to set
%define ALLOC_DIRECTORY_ENTRY_COUNT			PAGE_COUNT / PAGE_TABLE_ENTRY_COUNT	;number of page directory entries to set

%define GDTR64_LOCATION						0x00001000
%define GDT64_LOCATION						GDTR64_LOCATION + 10 ;in the same segment as memory map, it's gonna be the system memory

%define TOTAL_PAGES_REQUIRED				4096 * 4 + 4095	;pages needed to allocate everything

%define OLD_SCREEN_MEM_ADDR					0xA0000
%define NEW_SCREEN_MEM_ADDR					0x4000000

%endif ;PAGING_INC
