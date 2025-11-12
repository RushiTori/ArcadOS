bits         64

%include "engine/shapes_algo_base.inc"

section      .text

; Source:
; Bresenham's Line Algorithm - Demystified Step by Step By "NoBS Code"
; https://www.youtube.com/watch?v=CceepU1vIKo

; bool line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
func(global, line_algo_base)
	push r12    ; preserve r12
	push r13    ; preserve r13
	push r14    ; preserve r14
	push r15    ; preserve r15
	push rbx    ; preserve rbx
	push rbp    ; preserve rbp
	sub  rsp, 8 ; to re-align the stack

	;
	; uint16_t currX = aX;
	; uint16_t currY = aY;
	; uint16_t endX = bX;
	; uint16_t endY = bY;
	; uint16_t distX = abs(((int16_t)aX) - ((int16_t)bX));
	; uint16_t distY = abs(((int16_t)aY) - ((int16_t)bY));
	; int16_t dirX = (aX <= bX) 1 : -1;
	; int16_t dirY = (aY <= bY) 1 : -1;
	;

	mov r12w, di ; r12w = currX
	mov r13w, si ; r13w = currY

	mov r14w, di    ; r14w = aX
	sub r14w, dx    ; r14w = aX - bX
	;jg  .skip_abs_x
	jns .skip_abs_x ;you wanna jump if not negative, not if you have a carry, a carry can still lead to a positive number when you got an overflow or something like that
				   ;jns checks for not(sign flag), which is modified by sub
		neg r14w ; if (r14w < 0) r14w = -r14w
	.skip_abs_x: ; r14w = distX

	mov r15w, si    ; r15w = aY
	sub r15w, cx    ; r15w = aY - bY
	;jg  .skip_abs_y
	jns .skip_abs_y 
		neg r15w ; if (r15w < 0) r15w = -r15w
	.skip_abs_y: ; r15w = distY

	; bx = endX or endY
	mov bp, 1 ; bp = dirX or dirY

	cmp r14w, r15w
	jle line_algo_base_vertical ;they were swapped
	jmp line_algo_base_horizontal

func(static, line_algo_base_end)
	.with_fail:
		mov  di, r12w        ; di = currX
		mov  si, r13w        ; si = currY
		call screenvec2_pack ; screenvec2_pack(currX, currY);

		mov ScreenVec2_p [shapes_algo_base_fail_pos], eax

		mov al, true

	.without_fail:
	add rsp, 8 ; to re-align the stack
	pop rbp    ; restore rbp
	pop rbx    ; restore rbx
	pop r15    ; restore r15
	pop r14    ; restore r14
	pop r13    ; restore r13
	pop r12    ; restore r12
	ret

func(static, line_algo_base_horizontal)
	mov bx, dx ; bx = endX

	cmp si, cx              ; if (aY > bY) dirY = -1
	jle .skip_correct_dir_y
		neg bp
	.skip_correct_dir_y: ; bp = dirY

	shl r15w, 1    ; r15w = 2 * dy
	mov r11w, r15w ; r11w = 2 * dy
	sub r11w, r14w ; r11w = 2 * dy - dx
	shl r14w, 1    ; r14w = 2 * dx

	cmp di, dx ; (aX <= bX)? line_algo_base_left_to_right() : line_algo_base_right_to_left()

	jle line_algo_base_left_to_right
	jmp line_algo_base_right_to_left

func(static, line_algo_base_left_to_right)
	push r8 ; preserve call
	push r9 ; preserve isCond

	mov  di, r12w ; di = currX
	mov  si, r13w ; si = currY
	call r8       ; call(currX, currY);

	pop r9 ; restore isCond
	pop r8 ; restore call

	cmp r9b, false
	je  .skip_check_cond
		cmp al, false
		jne line_algo_base_end.with_fail
	.skip_check_cond:
	
	; if (currX == endX) goto line_algo_base_end.without_fail;
	cmp r12w, bx
	je  line_algo_base_end.without_fail

	cmp r11w, 0
	jl  .skip_adjust_other_axis
		add r13w, bp   ; currY += dirY
		sub r11w, r14w ; p -= 2 * distX
	.skip_adjust_other_axis:
	add r11w, r15w ; p += 2 * distY

	inc r12w ; currX++;

	jmp line_algo_base_left_to_right

func(static, line_algo_base_right_to_left)
	push r8 ; preserve call
	push r9 ; preserve isCond

	mov  di, r12w ; di = currX
	mov  si, r13w ; si = currY
	call r8       ; call(currX, currY);

	pop r9 ; restore isCond
	pop r8 ; restore call

	cmp r9b, false
	je  .skip_check_cond
		cmp al, false
		jne line_algo_base_end.with_fail
	.skip_check_cond:
	
	; if (currX == endX) goto line_algo_base_end.without_fail;
	cmp r12w, bx
	je  line_algo_base_end.without_fail

	cmp r11w, 0
	jl  .skip_adjust_other_axis
		add r13w, bp   ; currY += dirY
		sub r11w, r14w ; p -= 2 * distX
	.skip_adjust_other_axis:
	add r11w, r15w ; p += 2 * distY

	dec r12w ; currX--;

	jmp line_algo_base_right_to_left

func(static, line_algo_base_vertical)
	mov bx, cx ; bx = endX

	cmp di, dx              ; if (aX > bX) dirX = -1
	jle .skip_correct_dir_x
		neg bp
	.skip_correct_dir_x: ; bp = dirX

	shl r14w, 1    ; r14w = 2 * dx
	mov r11w, r14w ; r11w = 2 * dx
	sub r11w, r15w ; r11w = 2 * dx - dy
	shl r15w, 1    ; r15w = 2 * dy

	cmp si, cx ; (aY <= bY)? line_algo_base_top_to_bottom() : line_algo_base_bottom_to_top()

	jle line_algo_base_top_to_bottom
	jmp line_algo_base_bottom_to_top

func(static, line_algo_base_top_to_bottom)
	push r8 ; preserve call
	push r9 ; preserve isCond

	mov  di, r12w ; di = currX
	mov  si, r13w ; si = currY
	call r8       ; call(currX, currY);

	pop r9 ; restore isCond
	pop r8 ; restore call

	cmp r9b, false
	je  .skip_check_cond
		cmp al, false
		jne line_algo_base_end.with_fail
	.skip_check_cond:
	
	; if (currY == endY) goto line_algo_base_end.without_fail;
	cmp r13w, bx
	je  line_algo_base_end.without_fail

	cmp r11w, 0
	jl  .skip_adjust_other_axis
		add r13w, bp   ; currX += dirX
		sub r11w, r15w ; p -= 2 * distY
	.skip_adjust_other_axis:
	add r11w, r14w ; p += 2 * distX

	inc r13w ; currY++;

	jmp line_algo_base_top_to_bottom

func(static, line_algo_base_bottom_to_top)
	push r8 ; preserve call
	push r9 ; preserve isCond

	mov  di, r12w ; di = currX
	mov  si, r13w ; si = currY
	call r8       ; call(currX, currY);

	pop r9 ; restore isCond
	pop r8 ; restore call

	cmp r9b, false
	je  .skip_check_cond
		cmp al, false
		jne line_algo_base_end.with_fail
	.skip_check_cond:
	
	; if (currY == endY) goto line_algo_base_end.without_fail;
	cmp r13w, bx
	je  line_algo_base_end.without_fail

	cmp r11w, 0
	jl  .skip_adjust_other_axis
		add r13w, bp   ; currX += dirX
		sub r11w, r15w ; p -= 2 * distY
	.skip_adjust_other_axis:
	add r11w, r14w ; p += 2 * distX

	dec r13w ; currY++;

	jmp line_algo_base_top_to_bottom

; bool line_algo_vec_base(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call, bool isCond);
func(global, line_algo_vec_base)
	push rcx ; preserve isCond
	push rdx ; preserve call
	push rsi ; preserve b
	
	call screenvec2_unpack ; screenvec2_unpack(a);
	pop  rdi               ; restore b

	push rdx    ; preserve a.y
	push rax    ; preserve a.x
	sub  rsp, 8 ; to re-align the stack
	
	call screenvec2_unpack ; screenvec2_unpack(b);
	
	add rsp, 8  ; to re-align the stack
	pop rdi     ; restore a.x
	pop rsi     ; restore a.y
	mov cx,  dx ; b.y
	mov dx,  ax ; b.x
	pop r8      ; restore call
	pop r9      ; restore isCond
	
	jmp line_algo_base
