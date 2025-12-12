%ifndef PAGING_INC
%define PAGING_INC

%define PAGE_SIZE							0x00001000

%define PAGE_TABLE_ENTRY_COUNT				512
%define PAGE_DIRECTORY_ENTRY_COUNT			512
%define PAGE_DIRECTORY_POINTER_ENTRY_COUNT	512
%define PAGE_PLM4T_ENTRY_COUNT				512

%define SYSTEM_PLM4T_ADDR					0x0010000 ;index of start of PLM4T 0x010000 - 0x010FFF
%define SYSTEM_PAGE_DIRECTORY_POINTER_ADDR	0x0011000 ;index of start of the page directory pointer 0x11000 - 0x11FFF
%define SYSTEM_PAGE_DIRECTORY_ADDR			0x0012000 ;index of start of the page directory 0x12000 - 0x12FFF
%define SYSTEM_PAGE_DIRECTORY_LFB_ADDR      0x0013000 ;index of start of the page directory for LFB specifically 0x13000 - 0x13FF
%define SYSTEM_PAGE_TABLE_ADDR				0x0014000 ;index of the start of page tables 0x14000 - 0x1BFFF
%define SYSTEM_PAGE_TABLE_LFB_ADDR          0x001C000 ;index of the start of page tables for LFB specifically 0x1C000 - 0x23FFF

%define SYSTEM_PAGE_STRUCT_SIZE             PAGE_TABLE_ENTRY_COUNT * 8 ;size of any paging structure, whether it be PLM4T, PDP, PD or PT
;so memory from 0x20000 to 0x25000 shall not be touched, might change the range if we page allocate more memory

%define SYSTEM_MEMORY_MAP_LEN				0x00000000
%define SYSTEM_MEMORY_MAP					0x00000002						;where the memory map is physically in memory


%define SYSTEM_PAGE_ADDRESSING_START		0x00001000						;first addressable memory
%define STSTEM_PAGE_LFB_ADDRESSING_START    0xE0000000
%define SYSTEM_PAGE_SKIP					(SYSTEM_PAGE_ADDRESSING_START / PAGE_SIZE) ;number of page table entries to skip in order to keep the memory addressing start correct
%define TEMPORARY_PAGE_COUNT                PAGE_TABLE_ENTRY_COUNT
%define PAGE_COUNT							PAGE_TABLE_ENTRY_COUNT * 64 * 2			;number of page table entries to set
%define TEMP_ALLOC_DIRECTORY_ENTRY_COUNT    TEMPORARY_PAGE_COUNT / PAGE_TABLE_ENTRY_COUNT	;number of page directory entries to set
%define ALLOC_DIRECTORY_ENTRY_COUNT			PAGE_COUNT / PAGE_TABLE_ENTRY_COUNT	;number of page directory entries to set

%define GDTR64_LOCATION						0x000D1000
%define GDT64_LOCATION						GDTR64_LOCATION + 10 ;in the same segment as memory map, it's gonna be the system memory

%define TOTAL_PAGES_REQUIRED				4096 * 4 + 4095	;pages needed to allocate everything

%define OLD_SCREEN_MEM_ADDR					0xA0000
%define NEW_SCREEN_MEM_ADDR					0x400000

%endif ;PAGING_INC
