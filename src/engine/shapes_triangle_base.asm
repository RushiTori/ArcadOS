bits        64
default     rel

%include "engine/shapes_algo_base.inc"

section     .bss

res(static, pointer_t, sub_call)

anchor:
static      anchor: data
	istruc ScreenVec2
		at ScreenVec2.x, .x: resw 1
		at ScreenVec2.y, .y: resw 1
	iend

res(static, bool_t, is_cond)

section     .text

%macro check_for_fail_pos 0
	cmp bl, false
	je  %%skip_check_fail
		cmp al, false
		jne .restore_end
	%%skip_check_fail:
%endmacro

; bool triangle_fill_fan(uint16_t x, uint16_t y);
func(static, triangle_fill_fan)
	mov dx,  uint16_p [anchor.x]
	mov cx,  uint16_p [anchor.y]
	mov r8,  pointer_p [sub_call]
	mov r9b, bool_p [is_cond]
	jmp line_algo_base

; bool triangle_fill_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
func(global, triangle_fill_algo_base)
	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx

	mov r12d,                 edi                 ; r12d = a
	mov r13d,                 esi                 ; r13d = b
	mov r14d,                 edx                 ; r14d = c
	lea r15,                  [triangle_fill_fan] ; r15 = triangle_fill_fan
	mov bl,                   r8b                 ; bl = isCond
	mov pointer_p [sub_call], rcx                 ; preserve call
	mov bool_p [is_cond],     r8b                 ; preserve isCond

	; mov  edi,                   r12d ; edi = a
	; mov  esi,                   r13d ; esi = b
	mov  ScreenVec2_p [anchor], r14d ; anchor = c
	mov  rdx,                   r15  ; rdx = trianle_fill_fan
	mov  cl,                    bl   ; cl = isCond
	call line_algo_vec_base          ; line_algo_vec_base(a, b, triangle_fill_fan, isCond);
	check_for_fail_pos

	mov  edi,                   r13d ; edi = b
	mov  esi,                   r14d ; esi = c
	mov  ScreenVec2_p [anchor], r12d ; anchor = a
	mov  rdx,                   r15  ; rdx = trianle_fill_fan
	mov  cl,                    bl   ; cl = isCond
	call line_algo_vec_base          ; line_algo_vec_base(b, c, triangle_fill_fan, isCond);
	check_for_fail_pos

	mov  edi,                   r14d ; edi = c
	mov  esi,                   r12d ; esi = a
	mov  ScreenVec2_p [anchor], r13d ; anchor = b
	mov  rdx,                   r15  ; rdx = trianle_fill_fan
	mov  cl,                    bl   ; cl = isCond
	call line_algo_vec_base          ; line_algo_vec_base(c, a, triangle_fill_fan, isCond);
	check_for_fail_pos

	.restore_end:
		pop rbx ; restore rbx
		pop r15 ; restore r15
		pop r14 ; restore r14
		pop r13 ; restore r13
		pop r12 ; restore r12

	.end:
	ret

; bool triangle_line_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
func(global, triangle_line_algo_base)
	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx

	mov r12d, edi ; r12d = a
	mov r13d, esi ; r13d = b
	mov r14d, edx ; r14d = c
	mov r15,  rcx ; r15 = call
	mov bl,   r8b ; bl = isCond

	; mov  edi,  r12d          ; edi = a
	; mov  esi,  r13d          ; esi = b
	mov  rdx, r15           ; rdx = call
	mov  cl,  bl            ; cl = isCond
	call line_algo_vec_base ; line_algo_vec_base(a, b, call, isCond);
	check_for_fail_pos

	mov  edi, r13d          ; edi = b
	mov  esi, r14d          ; esi = c
	mov  rdx, r15           ; rdx = call
	mov  cl,  bl            ; cl = isCond
	call line_algo_vec_base ; line_algo_vec_base(b, c, call, isCond);
	check_for_fail_pos

	mov  edi, r14d          ; edi = c
	mov  esi, r12d          ; esi = a
	mov  rdx, r15           ; rdx = call
	mov  cl,  bl            ; cl = isCond
	call line_algo_vec_base ; line_algo_vec_base(c, a, call, isCond);
	check_for_fail_pos

	.restore_end:
		pop rbx ; restore rbx
		pop r15 ; restore r15
		pop r14 ; restore r14
		pop r13 ; restore r13
		pop r12 ; restore r12

	.end:
	ret
