%ifndef MEMORY_MOVER_INC
%define MEMORY_MOVER_INC

%include "string64.inc"

; We reserve that for the GDT's the IDT, the Paging table, the VGA Memory and the Stack base
; And the first 0x1000 bytes of it cause a page fault if accessed
%define ILLEGAL_MEMORY_START 0x0000000
%define ILLEGAL_MEMORY_END   0x0FFFFFF 
%define ILLEGAL_MEMORY_SIZE  (ILLEGAL_MEMERY_END - ILLEGAL_MEMERY_START) ; 16-ish megabytes

; The memory map for the .text sections
%define CODE_MEMORY_START    0x1000000
%define CODE_MEMORY_END      0x1FFFFFF 
%define CODE_MEMORY_SIZE     (CODE_MEMORY_END - CODE_MEMORY_START)       ; 16-ish megabytes

; The memory map for the .data sections
%define DATA_MEMORY_START    0x2000000
%define DATA_MEMORY_END      0x2FFFFFF 
%define DATA_MEMORY_SIZE     (DATA_MEMORY_END - DATA_MEMORY_START)       ; 16-ish megabytes

; The memory map for the .bss sections
%define BSS_MEMORY_START     0x3000000
%define BSS_MEMORY_END       0x3FFFFFF 
%define BSS_MEMORY_SIZE      (BSS_MEMORY_END - BSS_MEMORY_START)         ; 16-ish megabytes

; The memory map for the .rodata sections
%define RODATA_MEMORY_START  0x4000000
%define RODATA_MEMORY_END    0x4FFFFFF 
%define RODATA_MEMORY_SIZE   (RODATA_MEMORY_END - RODATA_MEMORY_START)   ; 16-ish megabytes

%define MIN_MEMORY_ADDR      0x0000000
%define MAX_MEMORY_ADDR      0x8000000 ; 128-ish megabytes

extern memory_mover_start

%endif ; MEMORY_MOVER_INC
