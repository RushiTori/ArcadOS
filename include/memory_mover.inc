%ifndef MEMORY_MOVER_INC
%define MEMORY_MOVER_INC

%include "string64.inc"

; The memory map for the .text sections
%define CODE_MEMORY_START     0x0007C00
%define CODE_MEMORY_END       0x1000000 
%define CODE_MEMORY_SIZE      (CODE_MEMORY_END - CODE_MEMORY_START)         ; 16-ish megabytes

; I want to keep that
; 0x0000000 - 0x0001000 : non adressable, pagefault
; 0x0001000 - 0x0007C00 : nothing
; 0x0007C00 - 0x1000000 : raw ArcadOS code

; I want to move that elsewhere
; 0x00A0000 - 0x00B0000 : VGA memory
; 0x00B0000 - 0x0800000 : Stack
; 0x0800000 - 0x0801000 : GDT64
; 0x0801000 - 0x0802000 : IDT
; 0x0802000 - 0x0803000 : PL4T
; 0x0803000 - 0x0804000 : PDP
; 0x0804000 - 0x0805000 : PD
; 0x0805000 - 0x0845000 : Page Tables

; The memory map for the .data sections
%define DATA_MEMORY_START     0x1000000
%define DATA_MEMORY_END       0x2000000 
%define DATA_MEMORY_SIZE      (DATA_MEMORY_END - DATA_MEMORY_START)         ; 16-ish megabytes

; The memory map for the .bss sections
%define BSS_MEMORY_START      0x2000000
%define BSS_MEMORY_END        0x3000000 
%define BSS_MEMORY_SIZE       (BSS_MEMORY_END - BSS_MEMORY_START)           ; 16-ish megabytes

; The memory map for the .rodata sections
%define RODATA_MEMORY_START   0x3000000
%define RODATA_MEMORY_END     0x4000000 
%define RODATA_MEMORY_SIZE    (RODATA_MEMORY_END - RODATA_MEMORY_START)     ; 16-ish megabytes

; We reserve that for the GDT's the IDT, the Paging table, the VGA Memory and the Stack base
%define RESERVED_MEMORY_START 0x4000000
%define RESERVED_MEMORY_END   0x5000000 
%define RESERVED_MEMORY_SIZE  (RESERVED_MEMORY_END - RESERVED_MEMORY_START) ; 16-ish megabytes

; Ideally I want it to look like that
; 0x4000000 - 0x4010000 : VGA Memory
; 0x4010000 - 0x4020000 : VGA Buffer 1
; 0x4020000 - 0x4030000 : VGA Buffer 2
; 0x4030000 - 0x4031000 : GDT64
; 0x4031000 - 0x4032000 : IDT
; 0x4032000 - 0x4033000 : PL4T
; 0x4033000 - 0x4034000 : PDP
; 0x4034000 - 0x4035000 : PD
; 0x4035000 - 0x4075000 : Page Tables
; 0x4075000 - 0x5000000 : Stack

%define MIN_MEMORY_ADDR      0x0000000
%define MAX_MEMORY_ADDR      0x8000000 ; 128-ish megabytes

extern memory_mover_start

%endif ; MEMORY_MOVER_INC
