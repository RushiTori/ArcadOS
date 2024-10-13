bits 64

%include "string.inc"

section .rodata

base_alphabet:
static base_alphabet:data
	db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

section .bss

itoa_buffer:
static itoa_buffer:data
	resb 64 + 1 + 1
itoa_buffer_len equ ($ - itoa_buffer)

utoa_buffer:
static utoa_buffer:data
	resb 64 + 1
utoa_buffer_len equ ($ - utoa_buffer)

section .text

; args : void* dest, u8 value, u64 n
; return : dest
memset:
global memset:function
	mov rax, rdi
	movzx rsi, sil
	movzx rax, sil

	shr rax, 8
	or rax, rsi
	or rsi, rax

	shr rax, 16
	or rax, rsi
	or rsi, rax

	shr rax, 32
	or rax, rsi
	or rsi, rax

	mov rcx, rdx
	shr rcx, 3
	rep stosq

	mov rcx, rdx
	and rcx, 0b111
	rep stosb
	ret

; args : void* dest, void* src, u64 n
; return : dest
memcpy:
global memcpy:function
	mov rax, rdi

	mov rcx, rdx
	shr rcx, 3
	rep movsq

	mov rcx, rdx
	and rcx, 0b111
	rep movsb
	ret

; args : void* dest, void* src, u64 n
; return : dest
memmove:
global memmove:function
	cmp rdi, rsi
	jbe memcpy
	mov rax, rdi

	add rdi, rdx
	dec rdi
	add rsi, rdx
	dec rsi
	std

	mov rcx, rdx
	shr rcx, 3
	rep movsq

	mov rcx, rdx
	and rcx, 0b111
	rep movsb
	cld
	ret

; args : u8* str
; return : number of bytes before the first byte equal to '\0'
strlen:
global strlen:function
	xor rax, rax
	.len_loop:
		cmp byte[rdi + rax], 0
		je .end
		inc rax
		jmp .len_loop
	.end:
	ret

; args : u8* dest, u8* src
; return : dest
strcat:
global strcat:function
	mov rcx, rdi

	xor rax, rax
	.skip_loop:
		cmp byte[rdi + rax], 0
		je .end_skip_loop
		inc rax
		jmp .skip_loop
	.end_skip_loop:

	.cpy_loop:
		lodsb
		stosb
		cmp al, 0
		jne .cpy_loop
	mov rax, rcx
	ret

; args : u8* dest, u8* src, u64 n
; return : dest
strncat:
global strncat:function
	mov rcx, rdi

	xor rax, rax
	.skip_loop:
		cmp byte[rdi + rax], 0
		je .end_skip_loop
		inc rax
		jmp .skip_loop
	.end_skip_loop:

	.cpy_loop:
		lodsb
		stosb
		dec rdx
		jz .end_n
		cmp al, 0
		jne .cpy_loop
		jmp .end_0
	.end_n:
	mov byte[rdi], 0
	.end_0:
	mov rax, rcx
	ret

; args : u8* dest, u8* src
; return : dest
strcpy:
global strcpy:
	mov rcx, rdi
	.cpy_loop:
		lodsb
		stosb
		cmp al, 0
		jne .cpy_loop
	mov rax, rcx
	ret

num_to_ascii_base:
static num_to_ascii_base:function
	mov rcx, rax
	mov r8, rax
	mov rax, rdi
	mov rdi, rdx

	.convert_loop:
		xor rdx, rdx
		div rdi
		mov dl, byte[base_alphabet + rdx]
		mov byte[rcx], dl
		inc rcx
		cmp rax, 0
		jne .convert_loop
	mov byte[rcx], 0

	mov rax, r8

	dec rcx
	.reverse_loop:
		mov dl, byte[rcx]
		mov dil, byte[r8]

		mov byte[rcx], dil
		mov byte[r8], dl

		dec rcx
		inc r8
		cmp rcx, r8
		jg .reverse_loop

	ret

; args : s64 num, u8* buffer, u8 base
; return : If 'base' is less than 2 or greater than 36, NULL,
;          else if 'buffer' is NULL, a static string containing 'num' represented in base 'base',
;          else 'buffer' and buffer will contain the string representation of 'num' in base 'base'.
; notes : Future calls will modify the static string if 'buffer' isn't NULL but utoa calls won't.
itoa:
global itoa:function
	xor rax, rax

	and rdx, 0xFF
	cmp rdx, 2
	jl .end
	cmp rdx, 36
	jg .end

	mov rax, rsi
	cmp rax, NULL
	jne .skip_use_static_buffer
	mov rax, itoa_buffer
	.skip_use_static_buffer:

	cmp rdi, 0
	jge .skip_neg
	mov byte[rax], '-'
	inc rax
	neg rdi
	.skip_neg:

	call num_to_ascii_base

	.end:
	ret

; args : u64 num, u8* buffer, u8 base
; return : If 'base' is less than 2 or greater than 36, NULL,
;          else if 'buffer' is NULL, a static string containing 'num' represented in base 'base',
;          else 'buffer' and buffer will contain the string representation of 'num' in base 'base'.
; notes : Future calls will modify the static string if 'buffer' isn't NULL but itoa calls won't.
utoa:
global utoa:function
	xor rax, rax

	cmp rdx, 2
	jl .end
	cmp rdx, 36
	jg .end

	mov rax, rsi
	cmp rax, NULL
	jne .skip_use_static_buffer
	mov rax, utoa_buffer
	.skip_use_static_buffer:

	call num_to_ascii_base

	.end:
	ret
