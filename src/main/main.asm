bits 64

%include "main/main.inc"
%include "engine/timer.inc"

section .bss

timerID:
static timerID:data
	resq 1

frameCount:
static frameCount:data
	resq 1

section .rodata

ArcadOSTitle:
static ArcadOSTitle:data
	db "ArcadOS", 0
ArcadOSTitleLen equ ($ - ArcadOSTitle)

seconds_0_padding:
static seconds_0_padding:data
	db ".000'000'000 seconds", 0

section .text

%define fps 600

convert_system_time:
static convert_system_time:function
	mov rax, 1
	cvtsi2sd xmm2, rax
	shl rax, 32
	cvtsi2sd xmm1, rax
	divsd xmm2, xmm1
	mov rax, 1000000
	cvtsi2sd xmm3, rax

	; mov eax, dword[system_timer_ms]
	; xor rdx, rdx
	; mov r12, 1000
	; div r12
	; mov r12, rax ; seconds
	; mov r13, rdx ; millis
	; mov eax, dword[system_timer_fractions]
	; cvtsi2sd xmm1, rax
	; mulsd xmm1, xmm2
	; mulsd xmm1, xmm3
	; cvtsd2si rax, xmm1
	; xor rdx, rdx
	; mov r14, 1000
	; div r14
	; mov r14, rax ; micros
	; mov r15, rdx ; nanos
	; ret
	call get_system_time_ms
	mov r14, rax
	shr rax, 32
	xor rdx, rdx
	mov r12, 1000
	div r12
	mov r12, rax ; seconds
	mov r13, rdx ; millis

	mov r15, 0xFFFFFFFF
	and r14, r15
	mov rax, r14
	cvtsi2sd xmm1, rax
	mulsd xmm1, xmm2
	mulsd xmm1, xmm3
	cvtsd2si rax, xmm1
	xor rdx, rdx
	mov r14, 1000
	div r14
	mov r14, rax ; micros
	mov r15, rdx ; nanos
	ret

draw_system_time:
static draw_system_time:function
	mov rdi, r12
	xor rsi, rsi
	mov rdx, 10
	call utoa

	mov rdi, rax
	call strlen
	push rax
	push rax
	push rax
	push rax

	mov rdx, rdi
	xor rdi, rdi
	mov rsi, SCREEN_HEIGHT - 8
	push rdx
	push rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text

	pop rdi
	shl rdi, 3
	mov rsi, SCREEN_HEIGHT - 8
	mov rdx, seconds_0_padding
	call draw_text_background
	mov rdx, seconds_0_padding
	call draw_text_shadow
	mov rdx, seconds_0_padding
	call draw_text

	mov rdi, r13
	xor rsi, rsi
	mov rdx, 10
	call utoa
	mov rdi, rax
	call strlen
	mov rdx, rdi
	pop rdi
	add rdi, 1 + 3
	sub rdi, rax
	shl rdi, 3
	mov rsi, SCREEN_HEIGHT - 8
	push rdx
	push rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text


	mov rdi, r14
	xor rsi, rsi
	mov rdx, 10
	call utoa
	mov rdi, rax
	call strlen
	mov rdx, rdi
	pop rdi
	add rdi, 1 + 3 + 1 + 3
	sub rdi, rax
	shl rdi, 3
	mov rsi, SCREEN_HEIGHT - 8
	push rdx
	push rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text


	mov rdi, r15
	xor rsi, rsi
	mov rdx, 10
	call utoa
	mov rdi, rax
	call strlen
	mov rdx, rdi
	pop rdi
	add rdi, 1 + 3 + 1 + 3 + 1 + 3
	sub rdi, rax
	shl rdi, 3
	mov rsi, SCREEN_HEIGHT - 8
	push rdx
	push rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text

	ret

main:
global main:function
	mov rax, cr0
	and ax, 0xFFFB		;clear coprocessor emulation CR0.EM
	or ax, 0x2			;set coprocessor monitoring  CR0.MP
	mov cr0, rax
	mov rax, cr4
	or ax, 3 << 9		;set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
	mov cr4, rax
	; WIP
	call memory_mover_start
	mov rbx, fps
	call init_PIT
	call create_timer
	cmp rax, -1
	je $
	mov qword[timerID], rax

	dec qword[frameCount]

	.draw_loop:
	mov rdi, qword[timerID]
	call reset_timer
	inc qword[frameCount]

	; mov rdi, 0x2C
	; call set_color
	; call clear_screen

	mov rdi, qword[frameCount]
	xor rsi, rsi
	mov rdx, 10
	call utoa
	push rax
	push rax
	push rax

	xor rdi, rdi
	mov rsi, SCREEN_HEIGHT - 40
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text

	mov rax, qword[frameCount]
	mov rdi, 60
	xor rdx, rdx
	div rdi
	mov rdi, rax
	xor rsi, rsi
	mov rdx, 10
	call utoa
	push rax
	push rax
	push rax

	xor rdi, rdi
	mov rsi, SCREEN_HEIGHT - 32
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text


	call get_system_ticks
	mov rdi, rax
	xor rsi, rsi
	mov rdx, 10
	call utoa
	push rax
	push rax
	push rax

	xor rdi, rdi
	mov rsi, SCREEN_HEIGHT - 24
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text

	call get_system_ticks
	mov edi, dword[IRQ0_frequency]
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
	mov rsi, SCREEN_HEIGHT - 16
	pop rdx
	call draw_text_background
	pop rdx
	call draw_text_shadow
	pop rdx
	call draw_text
	
	call convert_system_time
	call draw_system_time

	call update_keyboard_handler

	mov rdi, qword[timerID]
	call get_timer_ms

	mov rdi, FRAME_TIME
	sub rdi, rax
	jc .draw_loop
	call sleep_ms


	jmp .draw_loop
