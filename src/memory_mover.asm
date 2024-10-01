bits 64

%include "memory_mover.inc"

section .text

memory_mover_start:
global memory_mover_start:function
	mov rdi, DATA_MEMORY_START
	mov rsi, 0x0D
	mov rdx, DATA_MEMORY_SIZE
	call memset

	mov rdi, DATA_MEMORY_START
	mov rsi, memory_mover_end + 8
	mov edx, dword[memory_mover_end]
	bswap edx
	call memcpy

	
	mov rdi, BSS_MEMORY_START
	xor rsi, rsi
	mov rdx, BSS_MEMORY_SIZE
	call memset

	
	mov rdi, RODATA_MEMORY_START
	xor rsi, rsi
	mov rdx, RODATA_MEMORY_SIZE
	call memset

	mov rdi, RODATA_MEMORY_START
	mov esi, dword[memory_mover_end]
	bswap esi
	add rsi, memory_mover_end + 8
	mov edx, dword[memory_mover_end + 4]
	bswap edx
	call memcpy
	ret

memory_mover_end:
static memory_mover_end:data
