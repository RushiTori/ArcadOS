bits        64

%include "engine/shapes_algo_base.inc"

section     .bss

res(static, pointer_t, circle_fill_sub_call)
res(static, uint16_t,  circle_fill_cx)
res(static, bool_t,    circle_fill_is_cond)

section     .text

%macro safe_sub_call 1
	cmp r9b, false
	je  %%simple_call

	push rdi ; preserve x
	push rsi ; preserve y
	push r9  ; preserve isCond
	call %1  ; call(x, y);
	pop  r9  ; restore isCond
	pop  rsi ; restore y
	pop  rdi ; restore x

	cmp al, false
	je  %%end_safe_sub_call

	call screenvec2_pack ; screenvec2_pack(x, y);

	mov ScreenVec2_p [shapes_algo_base_fail_pos], eax

	mov al, true
	jmp .end

	%%simple_call:
	sub  rsp, 8 ; to re-align the stack 
	call %1     ; call(x, y);
	add  rsp, 8 ; to re-align the stack

	%%end_safe_sub_call:
%endmacro

; bool circle_fill_algo_base_work(uint16_t x, uint16_t y);
func(static, circle_fill_algo_base_work)
	mov pointer_p [circle_fill_sub_call], r8  ; restore call
	mov uint16_p  [circle_fill_cx],       dx  ; restore x
	mov bool_p    [circle_fill_is_cond],  r9b ; restore isCond
	
	mov cx, si         ; cx = y
	jmp line_algo_base

; bool circle_fill_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
func(global, circle_fill_algo_base)
	mov pointer_p [circle_fill_sub_call], rcx ; preserve call
	mov uint16_p  [circle_fill_cx],       di  ; preserve x
	mov bool_p    [circle_fill_is_cond],  r8b ; preserve isCond

	lea rcx, [circle_fill_algo_base_work]
	jmp circle_line_algo_base

; bool circle_fill_algo_base(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call, bool isCond);
func(global, circle_fill_algo_vec_base)
	push r8  ; preserving isCond
	push rcx ; preserving call
	push rdx ; preserving r

	call screenvec2_unpack ; screenvec2_unpack(pos);

	mov di, ax ; di = pos.x
	mov si, dx ; si = pos.y
	pop rdx    ; rdx = r
	pop rcx    ; rcx = call
	pop r8     ; r8 = isCond

	jmp circle_fill_algo_vec_base

; bool circle_line_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
func(global, circle_line_algo_base)
	mov al, false
	cmp dl, 1
	jb  .nothing_to_draw
	je  plot_circle_as_point

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx
	push rbp ; preserve rbp

	;
	; uint16_t cX = x;
	; uint16_t cY = y;
	; uint16_t xOff = 0;
	; uint16_t yOff = -r;
	; uint16_t p = -r;
	;

	neg r8b ; r8b = -r

	mov   r12w, di   ; r12w = cX
	mov   r13w, si   ; r13w = cY
	xor   r14w, r14w ; r14w = xOff
	movzx r15w, r8b  ; r15w = yOff
	movzx bx,   r8b  ; bx = p
	mov   rbp,  rcx  ; rbp = call

	.algo_loop:
		mov al, false

		neg r15w ; r15w = -yOff

		cmp r14w, r15w
		jge .end_algo_loop ; if (xOff >= -yOff) break;
		
		neg r15w ; r15w = yOff

		cmp bx, 0
		jle .skip_adjust_y_offset
			inc r15w ; yOff++;

			shl r15w, 1    ; r15w = yOff * 2
			add bx,   r15w ; p += 2 * yOff
			shr r15w, 1    ; r15w = yOff
		.skip_adjust_y_offset:

		shl r14w, 1    ; r14w = xOff * 2
		add bx,   r14w ; p += 2 * xOff
		shr r14w, 1    ; r14w = xOff
		inc bx         ; p++;

		mov           di, r12w ; di = cX
		add           di, r14w ; di = cX + xOff
		mov           si, r13w ; si = cY
		add           si, r15w ; si = cY + yOff
		safe_sub_call rbp      ; call(cX + xOff, cY + yOff);

		mov           di, r12w ; di = cX
		sub           di, r14w ; di = cX - xOff
		mov           si, r13w ; si = cY
		add           si, r15w ; si = cY + yOff
		safe_sub_call rbp      ; call(cX - xOff, cY + yOff);

		mov           di, r12w ; di = cX
		add           di, r14w ; di = cX + xOff
		mov           si, r13w ; si = cY
		sub           si, r15w ; si = cY - yOff
		safe_sub_call rbp      ; call(cX + xOff, cY - yOff);

		mov           di, r12w ; di = cX
		sub           di, r14w ; di = cX - xOff
		mov           si, r13w ; si = cY
		sub           si, r15w ; si = cY - yOff
		safe_sub_call rbp      ; call(cX - xOff, cY - yOff);

		mov           di, r12w ; di = cX
		add           di, r15w ; di = cX + yOff
		mov           si, r13w ; si = cY
		add           si, r14w ; si = cY + xOff
		safe_sub_call rbp      ; call(cX + yOff, cY + xOff);

		mov           di, r12w ; di = cX
		sub           di, r15w ; di = cX - yOff
		mov           si, r13w ; si = cY
		add           si, r14w ; si = cY + xOff
		safe_sub_call rbp      ; call(cX - yOff, cY + xOff);

		mov           di, r12w ; di = cX
		add           di, r15w ; di = cX + yOff
		mov           si, r13w ; si = cY
		sub           si, r14w ; si = cY - xOff
		safe_sub_call rbp      ; call(cX + yOff, cY - xOff);

		mov           di, r12w ; di = cX
		sub           di, r15w ; di = cX - yOff
		mov           si, r13w ; si = cY
		sub           si, r14w ; si = cY - xOff
		safe_sub_call rbp      ; call(cX - yOff, cY - xOff);

		inc r14w ; xOff++
	.end_algo_loop:

	.end:
	pop rbp ; restore rbp
	pop rbx ; restore rbx
	pop r15 ; restore r15
	pop r14 ; restore r14
	pop r13 ; restore r13
	pop r12 ; restore r12

	.nothing_to_draw:
	ret

func(static, plot_circle_as_point)
	safe_sub_call r8
	.end:
	ret


; bool circle_line_algo_base(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call, bool isCond);
func(global, circle_line_algo_vec_base)
	push r8  ; preserving isCond
	push rcx ; preserving call
	push rdx ; preserving r

	call screenvec2_unpack ; screenvec2_unpack(pos);

	mov di, ax ; di = pos.x
	mov si, dx ; si = pos.y
	pop rdx    ; rdx = r
	pop rcx    ; rcx = call
	pop r8     ; r8 = isCond

	jmp circle_line_algo_base
