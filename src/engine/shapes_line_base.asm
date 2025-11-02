bits         64

%include "engine/shapes_algo_base.inc"

section      .text

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
	jg  .skip_abs_x
		neg r14w ; if (r14w < 0) r14w = -r14w
	.skip_abs_x: ; r14w = distX

	mov r15w, si    ; r15w = aY
	sub r15w, cx    ; r15w = aY - bY
	jg  .skip_abs_y
		neg r15w ; if (r15w < 0) r15w = -r15w
	.skip_abs_y: ; r15w = distY

	; bx = endX or endY
	mov bp, 1 ; bp = dirX or dirY

	cmp r14w, r15w
	jle line_algo_base_horizontal
	jmp line_algo_base_vertical

func(static, line_algo_base_horizontal)
	mov bx, dx ; bx = endX

	cmp si, cx              ; if (aY > bY) dirY = -1
	jle .skip_correct_dir_y
		neg bp
	.skip_correct_dir_y: ; bp = dirY

	; WIP

	cmp di, dx ; (aX <= bX)? line_algo_base_left_to_right() : line_algo_base_right_to_left()

	jle line_algo_base_left_to_right
	jmp line_algo_base_right_to_left

func(static, line_algo_base_left_to_right)
	; WIP
	ret

func(static, line_algo_base_right_to_left)
	; WIP
	ret

func(static, line_algo_base_vertical)
	mov bx, cx ; bx = endX

	cmp di, dx              ; if (aX > bX) dirX = -1
	jle .skip_correct_dir_x
		neg bp
	.skip_correct_dir_x: ; bp = dirX

	; WIP

	cmp di, dx ; (aY <= bY)? line_algo_base_top_to_bottom() : line_algo_base_bottom_to_top()

	jle line_algo_base_top_to_bottom
	jmp line_algo_base_bottom_to_top

func(static, line_algo_base_top_to_bottom)
	; WIP
	ret

func(static, line_algo_base_bottom_to_top)
	; WIP
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
