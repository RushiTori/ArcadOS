bits             64

%include "engine/shapes_algo_base.inc"

section          .text

; bool rect_fill_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
function(global, rect_fill_algo_base)
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
	; while (tY <= bY) {
	;   line_algo_base(lX, tY, rX, tY, call, isCond);
	;   tY++;
	; }
	;

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx
	push rbp ; preserve rbp

	mov r12w, di  ; r12w = lX
	mov r13w, si  ; r13w = tY
	mov r14w, dx  ; r14w = rX
	mov r15w, cx  ; r15w = bY
	mov rbx,  r8  ; rbx = call
	mov bpl,  r9b ; bpl = isCond

	.scan_loop:
		mov  di,   r12w     ; lX
		mov  dx,   r14w     ; rX
		mov  si,   r13w     ; tY
		mov  cx,   r13w     ; tY
		mov  r8,   rbx      ; call
		mov  r9b,  bpl      ; isCond
		call line_algo_base ; line_algo_base(lX, tY, rX, tY, call, isCond);
		inc  r13w
		cmp  r13w, r15w
		jle  .scan_loop

	push rbp ; restore rbp
	push rbx ; restore rbx
	push r15 ; restore r15
	push r14 ; restore r14
	push r13 ; restore r13
	push r12 ; restore r12

	.end:
	ret

; bool rect_line_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
function(global, rect_line_algo_base)
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

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx
	push rbp ; preserve rbp

	mov r12w, di  ; r12w = lX
	mov r13w, si  ; r13w = tY
	mov r14w, dx  ; r14w = rX
	mov r15w, cx  ; r15w = bY
	mov rbx,  r8  ; rbx = call
	mov bpl,  r9b ; bpl = isCond

	; mov  di, r12w       ; di = lX
	; mov  si, r13w       ; si = tY
	; mov  dx, r14w       ; dx = rX
	mov  cx, r13w       ; cx = tY
	; mov  r8,  rbx       ; r8 = call
	; mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, tY, rX, tY, call, isCond);

	mov  di,  r12w      ; di = lX
	mov  si,  r15w      ; si = bY
	mov  dx,  r14w      ; dx = rX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, bY, rX, bY, call, isCond);

	mov  di,  r12w      ; di = lX
	mov  si,  r13w      ; si = tY
	mov  dx,  r12w      ; dx = lX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(lX, tY, lX, bY, call, isCond);

	mov  di,  r14w      ; di = rX
	mov  si,  r13w      ; si = tY
	mov  dx,  r14w      ; dx = rX
	mov  cx,  r15w      ; cx = bY
	mov  r8,  rbx       ; r8 = call
	mov  r9b, bpl       ; r9b = isCond
	call line_algo_base ; line_algo_base(rX, tY, rX, bY, call, isCond);

	push rbp ; restore rbp
	push rbx ; restore rbx
	push r15 ; restore r15
	push r14 ; restore r14
	push r13 ; restore r13
	push r12 ; restore r12

	.end:
	ret
