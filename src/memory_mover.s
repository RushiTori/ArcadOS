bits 64

%include "memory_mover.inc"

memory_mover_start:
global memory_mover_start:function
	mov rdi, CODE_MEMORY_START
	xor rsi, rsi
	mov rdx, CODE_MEMORY_SIZE
	call memset64

	mov rdi, CODE_MEMORY_START
	mov rsi, 0x7C00
	mov rdx, memory_mover_end - 0x7C00
	call memcpy64

	
	mov rdi, DATA_MEMORY_START
	xor rsi, rsi
	mov rdx, DATA_MEMORY_SIZE
	call memset64

	mov rdi, DATA_MEMORY_START
	mov rsi, memory_mover_end + 8
	mov edx, dword[memory_mover_end]
	call memcpy64

	
	mov rdi, BSS_MEMORY_START
	xor rsi, rsi
	mov rdx, BSS_MEMORY_SIZE
	call memset64

	
	mov rdi, RODATA_MEMORY_START
	xor rsi, rsi
	mov rdx, RODATA_MEMORY_SIZE
	call memset64

	mov rdi, RODATA_MEMORY_START
	mov rsi, memory_mover_end + 8
	add esi, dword[memory_mover_end]
	mov edx, dword[memory_mover_end + 4]
	call memcpy64
	ret

memory_mover_end:
static memory_mover_end:data
