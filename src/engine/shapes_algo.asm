bits    64

%include "engine/shapes_algo.inc"

section .text

%macro screenvec2_unpack2_and_jump_to 1
	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	mov r8, rdx ; r8 = call

	push rsi               ; push b
	push r8                ; push call
	call screenvec2_unpack ; screenvec2_unpack(a);
	pop  r8                ; r8 = call
	pop  rdi               ; edi = b

	push r8  ; push call
	push rax ; push a.x
	push rdx ; push a.y

	sub  rsp, 8            ; to re-align the stack
	call screenvec2_unpack ; screenvec2_unpack(b);
	add  rsp, 8

	mov cx, dx ; cx = b.y
	mov dx, ax ; dx = b.x
	pop rsi    ; si = a.y
	pop rdi    ; di = a.x
	pop r8     ; r8 = call

	pop rbp ; exiting the stack frame

	jmp %1
%endmacro

%macro screenvec2_unpack_and_jump_to 1
	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	mov rcx, rdx ; rcx = call
	mov dl,  sil ; dl = r

	push rdx               ; push r
	push rcx               ; push call
	call screenvec2_unpack ; screenvec2_unpack(a);
	mov  di, ax            ; di = pos.x
	mov  si, dx            ; si = pos.y
	pop  rcx               ; rcx = call
	pop  rdx               ; dl = r

	pop rbp ; exiting the stack frame

	jmp %1
%endmacro

; void line_algo(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call);
function(global, line_algo)
	mov r9b, false
	jmp line_algo_base

; ScreenVec2 line_algo_cond(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCondCall call);
function(global, line_algo_cond)
	mov r9b, true
	jmp line_algo_base

; void line_algo_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call);
function(global, line_algo_vec)
	screenvec2_unpack2_and_jump_to line_algo

; ScreenVec2 line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCondCall call);
function(global, line_algo_cond_vec)
	screenvec2_unpack2_and_jump_to line_algo_cond

; void rect_fill_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
function(global, rect_fill_algo)
	mov r9b, false
	jmp rect_fill_algo_base

; ScreenVec2 rect_fill_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
function(global, rect_fill_algo_cond)
	mov r9b, true
	jmp rect_fill_algo_base

; void rect_fill_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
function(global, rect_fill_algo_vec)
	screenvec2_unpack2_and_jump_to rect_fill_algo

; ScreenVec2 rect_fill_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
function(global, rect_fill_algo_cond_vec)
	screenvec2_unpack2_and_jump_to rect_fill_algo_cond

; void rect_line_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
function(global, rect_line_algo)
	mov r9b, false
	jmp rect_line_algo_base

; ScreenVec2 rect_line_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
function(global, rect_line_algo_cond)
	mov r9b, true
	jmp rect_line_algo_base

; void rect_line_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
function(global, rect_line_algo_vec)
	screenvec2_unpack2_and_jump_to rect_line_algo

; ScreenVec2 rect_line_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
function(global, rect_line_algo_cond_vec)
	screenvec2_unpack2_and_jump_to rect_line_algo_cond

; void triangle_fill_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
function(global, triangle_fill_algo_vec)
	mov r9b, false
	jmp triangle_fill_algo_base

; ScreenVec2 triangle_fill_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
function(global, triangle_fill_algo_cond_vec)
	mov r9b, true
	jmp triangle_fill_algo_base

; void triangle_line_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
function(global, triangle_line_algo_vec)
	mov r9b, false
	jmp triangle_line_algo_base

; ScreenVec2 triangle_line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
function(global, triangle_line_algo_cond_vec)
	mov r9b, true
	jmp triangle_line_algo_base

; void circle_fill_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
function(global, circle_fill_algo)
	mov r9b, false
	jmp circle_fill_algo_base

; ScreenVec2 circle_fill_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
function(global, circle_fill_algo_cond)
	mov r9b, true
	jmp circle_fill_algo_base

; void circle_fill_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
function(global, circle_fill_algo_vec)
	screenvec2_unpack_and_jump_to circle_fill_algo

; ScreenVec2 circle_fill_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
function(global, circle_fill_algo_cond_vec)
	screenvec2_unpack_and_jump_to circle_fill_algo_cond

; void circle_line_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
function(global, circle_line_algo)
	mov r9b, false
	jmp circle_line_algo_base

; ScreenVec2 circle_line_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
function(global, circle_line_algo_cond)
	mov r9b, true
	jmp circle_line_algo_base

; void circle_line_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
function(global, circle_line_algo_vec)
	screenvec2_unpack_and_jump_to circle_line_algo

; ScreenVec2 circle_line_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
function(global, circle_line_algo_cond_vec)
	screenvec2_unpack_and_jump_to circle_line_algo_cond

; SreenVec2? line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
function(static, line_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? rect_fill_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
function(static, rect_fill_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? rect_line_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
function(static, rect_line_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? triangle_fill_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
function(static, triangle_fill_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? triangle_line_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
function(static, triangle_line_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? circle_fill_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
function(static, circle_fill_algo_base)
	; WIP
	.end:
	ret

; SreenVec2? circle_line_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
function(static, circle_line_algo_base)
	; WIP
	.end:
	ret
