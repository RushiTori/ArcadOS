bits         64
default      rel

%include "engine/shapes_algo_base.inc"

section      .bss

res(static,  bool_t, is_cond)

section      .text

; Source:
; void plotLine(int x0, int y0, int x1, int y1);
; https://zingl.github.io/bresenham.html
; https://zingl.github.io/bresenham.c

; bool line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
func(global, line_algo_base)
	push r12    ; preserve r12
	push r13    ; preserve r13
	push r14    ; preserve r14
	push r15    ; preserve r15
	push rbx    ; preserve rbx
	push rbp    ; preserve rbp
	sub  rsp, 8 ; to re-align the stack and make room for args

	mov r14w, 1  ; sx = 1
	mov r15w, -1 ; sy = -1

	mov r12w, dx    ; x1
	sub r12w, di    ; x1 - x0
	jg  .skip_abs_x ; if (x1 > x0) goto skip_abs_x;
		neg r14w ; sx = -1
		neg r12w
	.skip_abs_x: ; r12w = abs(x1 - x0);

	mov r13w, cx    ; y1
	sub r13w, si    ; y1 - y0
	jle .skip_abs_y ; if (y1 <= y0) goto skip_abs_y;
		neg r15w ; sy = 1
		neg r13w
	.skip_abs_y: ; r13w = -abs(y1 - y0);
	
	mov bx, r12w ; bx = "dx"
	add bx, r13w ; bx = "dx" + dy

	mov rbp, r8 ; call

	cmp   r9b, false
	setne bool_p [is_cond] ; is_cond = (bool_t)isCond

	.algo_loop:
		; WIP
		mov uint16_p [rsp],             di ; preserve x0
		mov uint16_p [rsp + 2],         si ; preserve y0
		mov uint16_p [rsp + 2 + 2],     dx ; preserve x0
		mov uint16_p [rsp + 2 + 2 + 2], cx ; preserve y0

		call rbp ; call(x0, y0);

		mov di, uint16_p [rsp]             ; restore x0
		mov si, uint16_p [rsp + 2]         ; restore y0
		mov dx, uint16_p [rsp + 2 + 2]     ; restore x0
		mov cx, uint16_p [rsp + 2 + 2 + 2] ; restore y0

		cmp   al, false
		setne al        ; al = (bool_t)(call(x0, y0));

		add al, bool_p [is_cond]
		cmp al, 2
		je  .end_with_fail_pos   ; if (call(x0, y0) && is_cond) goto end_with_fail_pos;

		cmp di, dx
		jne .skip_break ; if (x0 != x1) goto skip_break;
		cmp si, cx
		jne .skip_break ; if (y0 != y1) goto skip_break;
			jmp .algo_loop_end
		.skip_break:
		
		mov ax, bx ; ax = err
		add ax, bx ; ax = err * 2

		cmp ax, r13w
		jl  .skip_adjust_x ; if (e2 < dy) goto skip_adjust_x;
			add bx, r13w ; err += dy
			add di, r14w ; x0 += sx
		.skip_adjust_x:

		cmp ax, r12w
		jg  .skip_adjust_y ; if (e2 < dx) goto skip_adjust_y;
			add bx, r12w ; err += dx
			add si, r15w ; y0 += sy
		.skip_adjust_y:

		jmp .algo_loop
	.algo_loop_end:
	
	mov al, false
	jmp .end

	.end_with_fail_pos:
		call screenvec2_pack                                ; screenvec2_pack(x0, y0);
		mov  ScreenVec2_p [shapes_algo_base_fail_pos], eax  ; shapes_algo_base_fail_pos = screenvec2_pack(x0, y0);
		mov  al,                                       true ; yes, there is a fail pos to retrieve

	.end:
	add rsp, 8 ; to re-align the stack
	pop rbp    ; restore rbp
	pop rbx    ; restore rbx
	pop r15    ; restore r15
	pop r14    ; restore r14
	pop r13    ; restore r13
	pop r12    ; restore r12
	ret

; bool line_algo_base(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call, bool isCond);
func(global, line_algo_vec_base)
	; WIP
	push rcx ; preserve isCond
	push rdx ; preserve call
	push rsi ; preserve b

	call screenvec2_unpack ; screenvec2_unpack(a);

	pop  rdi    ; restore b
	push rdx    ; preserve a.y
	push rax    ; preserve a.x
	sub  rsp, 8 ; to re-align the stack

	call screenvec2_unpack ; screenvec2_unpack(b);

	add rsp, 8         ; to re-align the stack
	pop rdi            ; restore a.x
	pop rsi            ; restore a.y
	mov cx,  dx        ; b.y
	mov dx,  ax        ; b.x
	pop r8             ; restore call
	pop r9             ; restore isCond
	jmp line_algo_base
