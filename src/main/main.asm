bits 64

%include "main/main.inc"
extern pit_ticks

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

	.draw_loop:
	
	mov rdi, qword[pit_ticks]
	xor rsi, rsi
	mov rdx, 10
	call utoa
	push rax
	push rax
	push rax

	xor rdi, rdi
	xor rsi, rsi
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text
	
	mov rax, qword[pit_ticks]
	mov rdi, 18
	mov rdx, 0
	div rdi

	mov rdi, rax
	xor rsi, rsi
	mov rdx, 10
	call utoa
	push rax
	push rax
	push rax

	xor rdi, rdi
	mov rsi, 8
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text

	;mov rcx, 0xFFFFFF * 4 
	;.wait_loop:
	;loop .wait_loop

	call update_keyboard_handler

	hlt
	jmp .draw_loop
