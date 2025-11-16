bits    64
default rel

%include "engine/shapes_algo_base.inc"

section .text

%macro check_for_fail_pos 0
	cmp bpl, false
	je  %%skip_check_fail
		cmp al, false
		jne .restore_end
	%%skip_check_fail:
%endmacro

; bool rect_fill_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
func(global, rect_fill_algo_base)
	mov al, false

	cmp dx, 0
	je  .end  ; if (w == 0) return;

	cmp cx, 0
	je  .end  ; if (h == 0) return;

	;
	; uint16_t lX = x;
	; uint16_t rX = x + w - 1;
	; uint16_t tY = y;
	; uint16_t bY = y + h - 1;
	;
	; while (tY <= bY) {
	;   line_algo_base(lX, tY, rX, tY, call, isCond);
	;   tY++;
	; }
	;

	push r12    ; preserve r12
	push r13    ; preserve r13
	push r14    ; preserve r14
	push r15    ; preserve r15
	push rbx    ; preserve rbx
	push rbp    ; preserve rbp
	sub  rsp, 8 ; to re-align the stack

	mov r12w, di ; r12w = lX
	mov r13w, si ; r13w = tY

	mov r14w, di ; r14w = x
	add r14w, dx ; r14w = x + w
	dec r14w     ; r14w = x + w - 1

	mov r15w, si ; r15w = y
	add r15w, cx ; r15w = y + h
	dec r15w     ; r15w = y + h - 1

	mov rbx, r8  ; rbx = call
	mov bpl, r9b ; bpl = isCond

	.scan_loop:
		mov  di,   r12w     ; lX
		mov  si,   r13w     ; tY
		mov  dx,   r14w     ; rX
		mov  cx,   r13w     ; tY
		mov  r8,   rbx      ; call
		mov  r9b,  bpl      ; isCond
		call line_algo_base ; line_algo_base(lX, tY, rX, tY, call, isCond);
		check_for_fail_pos
		inc  r13w           ;tY++
		cmp  r13w, r15w
		jle  .scan_loop     ; while(tY <= bY);
	
	.restore_end:
		add rsp, 8 ; to re-align the stack
		pop rbp    ; restore rbp
		pop rbx    ; restore rbx
		pop r15    ; restore r15
		pop r14    ; restore r14
		pop r13    ; restore r13
		pop r12    ; restore r12

	.end:
	ret

; bool rect_fill_algo_base(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call, bool isCond);
func(global, rect_fill_algo_vec_base)
	push rcx ; preserve isCond
	push rdx ; preserve call
	push rsi ; preserve sizes
	
	call screenvec2_unpack ; screenvec2_unpack(pos);
	pop  rdi               ; restore sizes

	push rdx    ; preserve pos.y
	push rax    ; preserve pos.x
	sub  rsp, 8 ; to re-align the stack
	
	call screenvec2_unpack ; screenvec2_unpack(sizes);
	
	add rsp, 8  ; to re-align the stack
	pop rdi     ; restore pos.x
	pop rsi     ; restore pos.y
	mov cx,  dx ; sizes.y (h)
	mov dx,  ax ; sizes.x (w)
	pop r8      ; restore call
	pop r9      ; restore isCond
	
	jmp rect_fill_algo_base

; bool rect_line_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
func(global, rect_line_algo_base)
	mov al, false

	cmp dx, 0
	je  .end

	cmp cx, 0
	je  .end

	;
	; uint16_t lX = x;
	; uint16_t rX = x + w - 1;
	; uint16_t tY = y;
	; uint16_t bY = y + h - 1;
	;
	; Top
	; line_algo_base(lX, tY, rX, tY, call, isCond);
	;
	; Bottom
	; line_algo_base(lX, bY, rX, bY, call, isCond);
	;
	; Left
	; line_algo_base(lX, tY, lX, bY, call, isCond);
	;
	; Right
	; line_algo_base(rX, tY, rX, bY, call, isCond);
	;

	dec dx     ; w - 1
	add dx, di ; rX
	dec cx     ; h - 1
	add cx, si ; bY

	push r12    ; preserve r12
	push r13    ; preserve r13
	push r14    ; preserve r14
	push r15    ; preserve r15
	push rbx    ; preserve rbx
	push rbp    ; preserve rbp
	sub  rsp, 8 ; to re-align the stack

	mov r12w, di ; r12w = lX
	mov r13w, si ; r13w = tY

	mov r14w, di ; r14w = x
	add r14w, dx ; r14w = x + w
	dec r14w     ; r14w = x + w - 1

	mov r15w, si ; r15w = y
	add r15w, cx ; r15w = y + h
	dec r15w     ; r15w = y + h - 1

	mov rbx, r8  ; rbx = call
	mov bpl, r9b ; bpl = isCond

	; mov  di, r12w       ; di = lX
	; mov  si, r13w       ; si = tY
	mov  dx, r14w       ; dx = rX
	mov  cx, r13w       ; cx = tY
	; mov  r8,  rbx       ; r8 = call
	; mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, tY, rX, tY, call, isCond);
	check_for_fail_pos

	mov  di,  r12w      ; di = lX
	mov  si,  r15w      ; si = bY
	mov  dx,  r14w      ; dx = rX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, bY, rX, bY, call, isCond);
	check_for_fail_pos

	mov  di,  r12w      ; di = lX
	mov  si,  r13w      ; si = tY
	mov  dx,  r12w      ; dx = lX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, tY, lX, bY, call, isCond);
	check_for_fail_pos

	mov  di,  r14w      ; di = rX
	mov  si,  r13w      ; si = tY
	mov  dx,  r14w      ; dx = rX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(rX, tY, rX, bY, call, isCond);
	check_for_fail_pos

	.restore_end:
		add rsp, 8 ; to re-align the stack
		pop rbp    ; restore rbp
		pop rbx    ; restore rbx
		pop r15    ; restore r15
		pop r14    ; restore r14
		pop r13    ; restore r13
		pop r12    ; restore r12

	.end:
	ret

; bool rect_line_algo_base(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call, bool isCond);
func(global, rect_line_algo_vec_base)
	push rcx ; preserve isCond
	push rdx ; preserve call
	push rsi ; preserve sizes
	
	call screenvec2_unpack ; screenvec2_unpack(pos);
	pop  rdi               ; restore sizes

	push rdx    ; preserve pos.y
	push rax    ; preserve pos.x
	sub  rsp, 8 ; to re-align the stack
	
	call screenvec2_unpack ; screenvec2_unpack(sizes);
	
	add rsp, 8  ; to re-align the stack
	pop rdi     ; restore pos.x
	pop rsi     ; restore pos.y
	mov cx,  dx ; sizes.y (h)
	mov dx,  ax ; sizes.x (w)
	pop r8      ; restore call
	pop r9      ; restore isCond
	
	jmp rect_line_algo_base
