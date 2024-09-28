bits 64

%include "string64.inc"

section .text

; args : u64 dest, u64 src, u64 n
memcpy64:
global memcpy64:function
	cld

	mov rcx, rdx
	shr rcx, 3
	rep movsq

	mov rcx, rdx
	and rcx, 0b111
	rep movsb
	ret

; args : u64 dest, u8 value, u64 n
memset64:
global memset64:function
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
	cld

	mov rcx, rdx
	shr rcx, 3
	rep stosq

	mov rcx, rdx
	and rcx, 0b111
	rep stosb
	ret
