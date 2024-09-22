bits 64

%include "string64.inc"

memcpy64:
	cld
	.loop64:
		cmp edx, 8
		jl .end_loop64
		movsq
		sub edx, 8
		jmp .loop64
	.end_loop64:
	.loop8:
		cmp edx, 0
		je .end_loop8
		movsb
		dec edx
		jmp .loop8
	.end_loop8:
	ret
