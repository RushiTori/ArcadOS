bits         64

%include "engine/shapes_algo_base.inc"

section      .text

; bool line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
func(global, line_algo_base)
	; WIP
	.end:
	ret

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
