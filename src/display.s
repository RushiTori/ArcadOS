bits 64

%include "display.inc"

section .data
current_color:
static current_color:data
	db 0x0B

section .text

; args : u8 color
set_color:
global set_color:function
	mov byte[current_color], dil
	ret

; args : 
clear_screen:
global clear_screen:function
	mov al, byte[current_color]

	mov rcx, (SCREEN_WIDTH * SCREEN_HEIGHT)
	mov rdi, VGA_MEMORY_ADDR
	rep stosb
	ret

; args : u16 x, u16 y
; return : rax (true if the pixel was put false otherwise)
put_pixel:
global put_pixel:function
	xor rax, rax

	cmp di, SCREEN_WIDTH
	jae .end
	cmp si, SCREEN_HEIGHT
	jae .end

	mov rax, SCREEN_WIDTH
	imul ax, si
	add ax, di

	push rbx
	mov bl, byte[current_color]
	mov byte[VGA_MEMORY_ADDR + rax], bl
	pop rbx

	mov rax, true
	.end:
	ret

; args : u16 x, u16 y, u16 len
put_pixel_row:
global put_pixel_row:function
	.draw_loop:
		cmp dx, 0
		je .end

		call put_pixel

		inc di
		dec dx

		jmp .draw_loop
	.end:
	ret

; args : u16 x, u16 y, u16 size
draw_square:
global draw_square:function
	mov cx, dx
	call draw_rect
	ret

; args : u16 x, u16 y, u16 w, u16 h
draw_rect:
global draw_rect:function
	mov r10w, di
	mov r11w, dx
	.draw_loop:
		cmp cx, 0
		je .end

		call put_pixel_row
		mov di, r10w
		mov dx, r11w
		inc si
		dec cx

		jmp .draw_loop
	.end:
	ret

; args : u16 x, u16 y, u16 size
draw_square_line:
global draw_square_line:function
	mov cx, dx
	call draw_rect_line
	ret

; args : u16 x, u16 y, u16 w, u16 h
draw_rect_line:
global draw_rect_line:function
	mov r8w, 1
	call draw_rect_line_ex
	ret

; args : u16 x, u16 y, u16 size, u16 thickness
draw_square_line_ex:
global draw_square_line_ex:function
	mov r8w, cx
	mov cx, dx
	call draw_rect_line_ex
	ret

; args : u16 x, u16 y, u16 w, u16 h, u16 thickness
draw_rect_line_ex:
global draw_rect_line_ex:function
	cmp r8w, 0
	je .end
	
	; if  the thickness is greater than half the width or height
	; then we can simply draw a rectangle
	mov r11w, dx
	shr r11w, 1
	cmp r8w, r11w
	jge .simplify_call
	
	mov r11w, cx
	shr r11w, 1
	cmp r8w, r11w
	jge .simplify_call

	push r12
	push r13
	push r14
	push r15

	mov r12w, di ; x
	mov r14w, dx ; w
	mov r15w, cx ; h

	mov cx, r8w ; thickness
	; draw_rect(x, y, w, thickness)
	call draw_rect

	; here si (y) is now y + thickness
	mov r13w, si ; y + thickness

	shl cx, 1 ; thickness * 2
	mov r9w, cx ; backup thickness * 2 in r9w
	mov cx, r15w ; cx = h
	sub cx, r9w ; cx -= thickness * 2
	; here cx (h) is now h - (thickness * 2)

	mov dx, r8w ; thickness
	; draw_rect(x, y + thickness, thickness, h - (thickness * 2))
	call draw_rect

	; here si (y) is now y + h - thickness
	mov r11w, si
	mov si, r13w

	mov cx, r15w ; cx = h
	sub cx, r9w ; cx -= thickness * 2
	; here cx (h) is back to h - (thickness * 2)

	add di, r14w ; x + w
	sub di, r8w ; (x + w) - thickness
	; draw_rect(x + w - thickness, y + thickness, thickness, h - (thickness * 2))
	call draw_rect
	; here si (y) is (y + thickness) + (h - (thickness * 2)) ==> y + h - thickness

	mov di, r12w ; x
	mov dx, r14w ; w
	mov cx, r8w ; thickness
	; draw_rect(x, y + h - thickness, w, thickness)
	call draw_rect

	pop r15
	pop r14
	pop r13
	pop r12

	jmp .end

	.simplify_call:
		call draw_rect

	.end:
	ret

; Bresenham's mid-point algorithm
; Sources : 
;   - Bresenham's Line Algorithm - Demystified Step by Step : https://www.youtube.com/watch?v=CceepU1vIKo 
; args : u16 x0, u16 y0, u16 x1, u16 y1
draw_line:
global draw_line:function
	mov r8w, dx
	sub r8w, di
	cmp di, dx
	jle .skip_abs_x
	imul r8w, -1
	.skip_abs_x:

	mov r9w, cx
	sub r9w, si
	cmp si, cx
	jle .skip_abs_y
	imul r9w, -1
	.skip_abs_y:
	
	cmp r8w, r9w
	jge draw_lineH
	jl draw_lineV

	; ret : the ret is handled by both draw_lineH and draw_lineV

; args : u16 x0, u16 y0, u16 x1, u16 y1
draw_lineH:
static draw_lineH:function
	cmp di, dx
	je .end ; if x0 == x1 there is no line to draw
	jl .skip_swap_end_points ; if the line already points right, no need to swap the end points
	xchg di, dx ; swaps x0 and x1
	xchg si, cx ; swaps y0 and y1
	.skip_swap_end_points:
	
	mov r8w, dx
	sub r8w, di ; delta_x = x1 - x0

	mov r9w, cx
	sub r9w, si ; delta_y = y1 - y0

	mov r10w, 1 ; dir = 1
	cmp si, cx
	jle .skip_correct_dir ; if the line already points down, no need to correct the dir or delta_y
	mov r10w, -1
	imul r9w, r10w
	.skip_correct_dir:

	shl r9w, 1 ; delta_y *= 2

	mov r11w, r9w
	sub r11w, r8w ; p = delta_y * 2 - delta_x
	
	shl r8w, 1 ; delta_x *= 2

	.draw_loop:
		call put_pixel

		cmp r11w, 0
		jl .skip_update_y
		add si, r10w ; y += dir
		sub r11w, r8w ; p -= delta_x * 2
		.skip_update_y:
		add r11w, r9w ; p += delta_y * 2
		
		inc di
		cmp di, dx
		jne .draw_loop

	.end:
	ret

; args : u16 x0, u16 y0, u16 x1, u16 y1
draw_lineV:
static draw_lineV:function
	cmp si, cx
	je .end
	jl .skip_swap_end_points
	xchg si, cx
	xchg di, dx
	.skip_swap_end_points:

	mov r8w, dx
	sub r8w, di

	mov r9w, cx
	sub r9w, si

	mov r10w, 1
	cmp di, dx
	jle .skip_correct_dir
	mov r10w, -1
	imul r8w, r10w
	.skip_correct_dir:

	shl r8w, 1

	mov r11w, r8w
	sub r11w, r9w
	
	shl r9w, 1

	.draw_loop:
		call put_pixel

		cmp r11w, 0
		jl .skip_update_x
		add di, r10w
		sub r11w, r9w
		.skip_update_x:
		add r11w, r8w
		
		inc si
		cmp si, cx
		jne .draw_loop

	.end:
	ret

; args : u16 x, u16 y, u16 radius
draw_circle:
global draw_circle:function
	; WIP
	ret

; args : u16 x, u16 y, u16 radius
draw_circle_line:
global draw_circle_line:function
	; WIP
	ret

PAD_SECTOR(SECTOR_SIZE * 2)
