bits 64

%include "display.inc"

; For now I assume the display engine starts at sector 16 (0-indexed)
; to give enough space for every setup steps we might need to do beforehand
org BOOT_START_ADDR + (SECTOR_SIZE * 16)

current_color:
	db 0

; args : u8 color
set_color:
	mov ax, di
	and ax, 0xFF
	mov byte[current_color], al
	ret

; args : u16 x, u16 y
; return : al (true if the pixel was put false otherwise)
put_pixel:
	xor al, al

	cmp di, SCREEN_WIDTH
	jae .end
	cmp si, SCREEN_HEIGHT
	jae .end

	push rdx
	push rcx

	movzx rax, si
	mov cx, SCREEN_WIDTH
	mul cx
	add ax, di

	pop rcx
	pop rdx
	
	mov cl, byte[current_color]
	mov byte[VGA_MEMORY_ADDR + rax], cl
	mov al, true
	.end:
	ret

; args : u16 x, u16 y, u16 len
put_pixel_row:
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
	mov cx, dx
	call draw_rect
	ret

; args : u16 x, u16 y, u16 w, u16 h
draw_rect:
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
	mov cx, dx
	call draw_rect_line
	ret

; args : u16 x, u16 y, u16 w, u16 h
draw_rect_line:
	mov r8w, 1
	call draw_rect_line_ex
	ret

; args : u16 x, u16 y, u16 size, u16 thickness
draw_square_line_ex:
	mov r8w, cx
	mov cx, dx
	call draw_rect_line_ex
	ret

; args : u16 x, u16 y, u16 w, u16 h, u16 thickness
draw_rect_line_ex:
	; WIP
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

; args : u16 x0, u16 y0, u16 x1, u16 y1
draw_line:
	; WIP
	ret

; args : u16 x, u16 y, u16 radius
draw_circle:
	; WIP
	ret

; args : u16 x, u16 y, u16 radius
draw_circle_line:
	; WIP
	ret
