bits        64
default     rel

%include "engine/shapes_algo.inc"

section     .bss

; Contains the last pos evaluated by a shape algo base that "failed"
; ScreenVec2 shapes_algo_base_fail_pos = {0};
res(global, ScreenVec2_t, shapes_algo_base_fail_pos)

section     .text

%macro screenvec2_unpack2_and_jump_to 1
	push rdx    ; preserve call
	push rsi    ; preserve vecB
	sub  rsp, 8 ; to re-align the stack

	call screenvec2_unpack ; screenvec2_unpack(vecA);
	
	add  rsp, 8 ; to re-align the stack
	pop  rdi    ; vecB
	push rdx    ; vecA.y
	push rax    ; vecA.x

	call screenvec2_unpack ; screenvec2_unpack(vecB);
	
	pop rdi    ; vecA.x
	pop rsi    ; vecA.x
	mov cx, dx ; vecB.y
	mov dx, ax ; vecB.x
	pop r8     ; call

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
func(global, line_algo)
	mov r9b, false
	jmp line_algo_base

; ScreenVec2 line_algo_cond(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCondCall call);
func(global, line_algo_cond)
	mov r9b, true
	jmp line_algo_base

; void line_algo_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call);
func(global, line_algo_vec)
	; screenvec2_unpack2_and_jump_to line_algo
	push rdx    ; preserve call
	push rsi    ; preserve vecB
	sub  rsp, 8 ; to re-align the stack

	call screenvec2_unpack ; screenvec2_unpack(vecA);
	
	add  rsp, 8 ; to re-align the stack
	pop  rdi    ; vecB
	push rdx    ; vecA.y
	push rax    ; vecA.x

	call screenvec2_unpack ; screenvec2_unpack(vecB);
	
	pop rdi       ; vecA.x
	pop rsi       ; vecA.x
	mov cx, dx    ; vecB.y
	mov dx, ax    ; vecB.x
	pop r8        ; call
	jmp line_algo

; ScreenVec2 line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCondCall call);
func(global, line_algo_cond_vec)
	screenvec2_unpack2_and_jump_to line_algo_cond

; void rect_fill_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
func(global, rect_fill_algo)
	mov r9b, false
	jmp rect_fill_algo_base

; ScreenVec2 rect_fill_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
func(global, rect_fill_algo_cond)
	mov r9b, true
	jmp rect_fill_algo_base

; void rect_fill_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
func(global, rect_fill_algo_vec)
	screenvec2_unpack2_and_jump_to rect_fill_algo

; ScreenVec2 rect_fill_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
func(global, rect_fill_algo_cond_vec)
	screenvec2_unpack2_and_jump_to rect_fill_algo_cond

; void rect_line_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
func(global, rect_line_algo)
	mov r9b, false
	jmp rect_line_algo_base

; ScreenVec2 rect_line_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
func(global, rect_line_algo_cond)
	mov r9b, true
	jmp rect_line_algo_base

; void rect_line_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
func(global, rect_line_algo_vec)
	screenvec2_unpack2_and_jump_to rect_line_algo

; ScreenVec2 rect_line_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
func(global, rect_line_algo_cond_vec)
	screenvec2_unpack2_and_jump_to rect_line_algo_cond

; void triangle_fill_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
func(global, triangle_fill_algo_vec)
	mov r8b, false
	jmp triangle_fill_algo_base

; ScreenVec2 triangle_fill_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
func(global, triangle_fill_algo_cond_vec)
	mov r8b, true
	jmp triangle_fill_algo_base

; void triangle_line_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
func(global, triangle_line_algo_vec)
	mov r8b, false
	jmp triangle_line_algo_base

; ScreenVec2 triangle_line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
func(global, triangle_line_algo_cond_vec)
	mov r8b, true
	jmp triangle_line_algo_base

; void circle_fill_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
func(global, circle_fill_algo)
	mov r8b, false
	jmp circle_fill_algo_base

; ScreenVec2 circle_fill_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
func(global, circle_fill_algo_cond)
	mov r8b, true
	jmp circle_fill_algo_base

; void circle_fill_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
func(global, circle_fill_algo_vec)
	screenvec2_unpack_and_jump_to circle_fill_algo

; ScreenVec2 circle_fill_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
func(global, circle_fill_algo_cond_vec)
	screenvec2_unpack_and_jump_to circle_fill_algo_cond

; void circle_line_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
func(global, circle_line_algo)
	mov r8b, false
	jmp circle_line_algo_base

; ScreenVec2 circle_line_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
func(global, circle_line_algo_cond)
	mov r8b, true
	jmp circle_line_algo_base

; void circle_line_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
func(global, circle_line_algo_vec)
	screenvec2_unpack_and_jump_to circle_line_algo

; ScreenVec2 circle_line_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
func(global, circle_line_algo_cond_vec)
	screenvec2_unpack_and_jump_to circle_line_algo_cond
