%ifndef MEMORY_MOVER_INC
%define MEMORY_MOVER_INC

%include "string.inc"

; The memory map for the .text sections
%define CODE_MEMORY_START     0x0007C00
%define CODE_MEMORY_END       0x1000000
%define CODE_MEMORY_SIZE      (CODE_MEMORY_END - CODE_MEMORY_START)         ; 16-ish megabytes

; real mode address space
; 0x0000000 - 0x0000FFF ; not addressable, causes page fault
; 0x0006000 - 0x0006FFF : IDT
; 0x0007000 - 0x0007BFF : Stack
; 0x0007C00 - 0x000FFFF : bootloader code
; 0x0010000 - 0x001FFFF : Paging tables
; 0x0020000 - 0x007FFFF : free memory
; 0x0080000 - 0x009FFFF : EBDA (reserved by BIOS basically)
; 0x00A0000 - 0x00BFFFF : VGA memory
; 0x00C0000 - 0x00C7FFF : Video BIOS (reserved by BIOS)
; 0x00C8000 - 0x00EFFFF : BIOS Expansions (reserved by BIOS)
; 0x00F0000 - 0x00FFFFF : Motherboard BIOS (reserved by BIOS)

; extended memory (check memory map to see what is or isn't valid memory for us)
; 0x0100000 - 0x01FFFFF : data section
; 0x0200000 - 0x02FFFFF : bss section
; 0x0300000 - 0x03FFFFF : rodata section
; 0x0400000 - 0x0EFFFFF : free memory
; 0x0F00000 - 0x0FFFFFF : ISA memory hole
; 0x1000000 - ????????? : more free memory, gotta check using memory map

; The memory map for the .data sections
%define DATA_MEMORY_START     0x100000	;	4096	pages
%define DATA_MEMORY_END       0x1FFFFF
%define DATA_MEMORY_SIZE      (DATA_MEMORY_END - DATA_MEMORY_START)         ; 1-ish megabytes

; The memory map for the .bss sections
%define BSS_MEMORY_START      0x200000	;	4096	pages
%define BSS_MEMORY_END        0x2FFFFF 
%define BSS_MEMORY_SIZE       (BSS_MEMORY_END - BSS_MEMORY_START)           ; 1-ish megabytes

; The memory map for the .rodata sections
%define RODATA_MEMORY_START   0x300000	;	4096	pages
%define RODATA_MEMORY_END     0x3FFFFF 
%define RODATA_MEMORY_SIZE    (RODATA_MEMORY_END - RODATA_MEMORY_START)     ; 1-ish megabytes

; We reserve that for the GDT's the IDT, the Paging table, the VGA Memory and the Stack base
%define RESERVED_MEMORY_START 0x400000	;	4096	pages
%define RESERVED_MEMORY_END   0x4FFFFF 	
%define RESERVED_MEMORY_SIZE  (RESERVED_MEMORY_END - RESERVED_MEMORY_START) ; 1-ish megabytes

; Ideally I want it to look like that
; 0x4000000 - 0x4010000 : VGA Memory		16		pages
; 0x4010000 - 0x4020000 : VGA Buffer 1		16		pages
; 0x4020000 - 0x4030000 : VGA Buffer 2		16		pages
; 0x4030000 - 0x4031000 : GDT64				1 		page
; 0x4031000 - 0x4032000 : IDT				1		page
; 0x4032000 - 0x4033000 : PL4T				1		page
; 0x4033000 - 0x4034000 : PDP				1		page
; 0x4034000 - 0x4035000 : PD				1		page
; 0x4035000 - 0x4075000 : Page Tables		64		pages
; 0x4075000 - 0x5000000 : Stack				3979	pages

%define MIN_MEMORY_ADDR      0x0000000
%define MAX_MEMORY_ADDR      0x8000000 ; 128-ish megabytes

extern memory_mover_start

%endif ; MEMORY_MOVER_INC
