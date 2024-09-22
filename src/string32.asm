bits 32

%include "string32.inc"

memcpy32:
	cld
	.loop32:
		cmp edx, 4
		jl .end_loop32
		movsd
		sub edx, 4
		jmp .loop32
	.end_loop32:
	.loop8:
		cmp edx, 0
		je .end_loop8
		movsb
		dec edx
		jmp .loop8
	.end_loop8:
	ret
