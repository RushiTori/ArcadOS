bits 64

%include "main/main.inc"

section .rodata

ArcadOSTitle:
static ArcadOSTitle:data
	db "ArcadOS", 0
ArcadOSTitleLen equ ($ - ArcadOSTitle)

section .text

main:
global main:function
	; WIP
	call memory_mover_start
	mov rdi, 0x13
	call set_color
	call clear_screen

	mov rdi, 0x12
	call set_color
	mov rdi, (SCREEN_WIDTH / 2) - ((ArcadOSTitleLen * 8) / 2) - 4
	mov rsi, 0
	mov rdx, (ArcadOSTitleLen * 8)
	mov rcx, 16
	call draw_rect


	xor r12, r12

	.draw_loop:

	mov rdi, 0x20
	add rdi, r12
	call set_font_color
	add rdi, 24 * 3
	call set_font_shadow_color
	add rdi, 24 * 3
	call set_font_background_color

	mov rdi, (SCREEN_WIDTH / 2) - ((ArcadOSTitleLen * 8) / 2)
	mov rsi, 4
	mov rdx, ArcadOSTitle
	call draw_text_background
	mov rdx, ArcadOSTitle
	call draw_text_shadow
	mov rdx, ArcadOSTitle
	call draw_text

	mov rcx, 0xFFFFFF * 3
	.wait_loop:
	loop .wait_loop

	inc r12
	cmp r12, 24
	jl .skip_modulo
	xor r12, r12
	.skip_modulo:

	jmp .draw_loop
