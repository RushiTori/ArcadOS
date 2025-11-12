bits         64

%include "engine/display.inc"

section      .data

var(static, uint8_t, current_display_color, 0x1F)
var(static, pointer_t, display_buffer_addr, NULL)
var(static, uint8_t, draw_line_ex_radius, 0)

section      .text

; pointer_t get_display_buffer(void);
func(global, get_display_buffer)
	mov rax, pointer_p [display_buffer_addr]
	ret

; void set_display_buffer(pointer_t buffer);
func(global, set_display_buffer)
	mov pointer_p [display_buffer_addr], rdi
	ret

; uint8_t get_display_color(void);
func(global, get_display_color)
	mov al, uint8_p [current_display_color]
	ret

; void set_display_color(uint8_t col);
func(global, set_display_color)
	mov uint8_p [current_display_color], dil
	ret

; void put_pixel(uint16_t x, uint16_t y);
func(global, put_pixel)
	push rdi    ; preserve x
	push rsi    ; preserve y
	sub  rsp, 8 ; to re-align the stack

	call get_display_color

	add rsp, 8      ; to re-align the stack
	pop rsi         ; restore y
	pop rdi         ; restore x
	mov rdx, rax	; put the display color into the col argument
	jmp put_pixel_c

; void put_pixel_c(uint16_t x, uint16_t y, uint8_t col);
func(global, put_pixel_c)
	and rdi, 0xFFFF
	cmp rdi, DISPLAY_WIDTH
	jae .end               ; if (x >= DISPLAY_WIDTH) return;

	and rsi, 0xFFFF
	cmp rsi, DISPLAY_HEIGHT
	jae .end                ; if (y >= DISPLAY_HEIGHT) return;

	push rdx                ; preserve col
	mov  rax, DISPLAY_WIDTH
	mul  rsi                ; rax = y * DISPLAY_WIDTH
	add  rdi, rax           ; rdi = y * DISPLAY_WIDTH + x

	push rdi    ; preserve display_buffer_offset
	sub  rsp, 8 ; to re-align the stack

	call get_display_buffer
	
	add rsp, 8 ; to re-align the stack
	pop rdi    ; restore display_buffer_offset
	pop rsi    ; restore col

	add rdi, rax ; rdi = display_buffer + y * DISPLAY_WIDTH + x
	
	mov uint8_p [rdi], sil

	.end:
	ret

; void put_pixel_vec(ScreenVec2 pos);
func(global, put_pixel_vec)
	sub rsp, 8 ; to re-align the stack

	call screenvec2_unpack ; screenvec2_unpack(pos);

	add rsp, 8 ; to re-align the stack

	mov di, ax    ; pos.x
	mov si, dx    ; pos.y
	jmp put_pixel ; put_pixel(pos.x, pos.y);

; void put_pixel_c_vec(ScreenVec2 pos, uint8_t col);
func(global, put_pixel_c_vec)
	push rsi ; preserve col

	call screenvec2_unpack ; screenvec2_unpack(pos);
	
	mov di, ax      ; pos.x
	mov si, dx      ; pos.y
	pop rdx         ; restore col
	jmp put_pixel_c ; put_pixel_c(pos.x, pos.y, col);

; void clear_screen(void);
func(global, clear_screen)
	sub rsp, 8 ; to re-align the stack

	call get_display_color ; get_display_color();

	add rsp, 8 ; to re-align the stack

	mov dil, al
	jmp clear_screen_c ; clear_screen_c(get_display_color());

; void clear_screen_c(uint8_t col);
func(global, clear_screen_c)
	push rdi ; preserve col

	call get_display_buffer ; get_display_buffer();

	mov rdi, rax ; rdi = get_display_buffer();
	
	pop rax ; restore col

	mov rcx, DISPLAY_BUFFER_SIZE
	rep stosb
	ret

; void draw_square(uint16_t x, uint16_t y, uint16_t size);
func(global, draw_square)
	mov cx, dx
	jmp draw_rect

; void draw_square_vec(ScreenVec2 pos, uint16_t size);
func(global, draw_square_vec)
	mov dx, si
	jmp draw_rect_vec

; void draw_square_line(uint16_t x, uint16_t y, uint16_t size);
func(global, draw_square_line)
	mov cx, dx
	jmp draw_rect_line

; void draw_square_line_vec(ScreenVec2 pos, uint16_t size);
func(global, draw_square_line_vec)
	mov dx, si
	jmp draw_rect_line_vec

; void draw_square_line_ex(uint16_t x, uint16_t y, uint16_t size, uint8_t thickness);
func(global, draw_square_line_ex)
	mov r8b, cl
	mov cx,  dx
	jmp draw_rect_line_ex

; void draw_square_line_ex_vec(ScreenVec2 pos, uint16_t size, uint8_t thickness);
func(global, draw_square_line_ex_vec)
	mov cl, dl
	mov dx, si
	jmp draw_rect_line_ex_vec

; void draw_rect(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
func(global, draw_rect)
	lea r8, [put_pixel]
	jmp rect_fill_algo

; void draw_rect_vec(ScreenVec2 pos, ScreeVec2 sizes);
func(global, draw_rect_vec)
	lea rdx, [put_pixel]
	jmp rect_fill_algo_vec

; void draw_rect_line(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
func(global, draw_rect_line)
	lea r8, [put_pixel]
	jmp rect_line_algo

; void draw_rect_line_vec(ScreenVec2 pos, ScreeVec2 sizes);
func(global, draw_rect_line_vec)
	lea rdx, [put_pixel]
	jmp rect_line_algo_vec

; void draw_rect_line_ex(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t thickness);
func(global, draw_rect_line_ex)
	cmp r8b, 0
	je  .nothing_to_draw
	cmp r8b, 1
	je  draw_rect_line

	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx

	; uint8_t thick = thickness;
	; uint16_t thick_2 = thickness * 2;
	;
	; Top
	; draw_rect(x - thick, y - thick, w + thick_2, thick_2);
	;
	; Bottom
	; draw_rect(x - thick, y + h, w + thick_2, thick_2);
	;
	; Left
	; draw_rect(x - thick, y, thick_2, h);
	;
	; Right
	; draw_rect(x + w, y, thick_2, h);

	and rdi, 0xFFFF
	and rsi, 0xFFFF
	and rdx, 0xFFFF
	and rcx, 0xFFFF
	and r8,  0xFF

	sub di,   r8w ; x - thick
	mov r12w, di  ; r12 = x - thick

	mov r13w, si  ; r13 = y
	sub si,   r8w ; y - thick

	shl r8w, 1   ; thick_2
	mov bx,  r8w ; rbx = thick_2

	add dx,   r8w ; w + thick_2
	mov r14w, dx  ; r14 = w + thick_2

	mov r15w, cx ; r15 = h

	mov  cx, r8w   ; thick_2
	call draw_rect ; draw_rect(x - thick, y - thick, w + thick_2, thick_2);

	mov  di, r12w  ; x - thick
	mov  si, r13w  ; y
	add  si, r15w  ; y + h
	mov  dx, r14w  ; w + thick_2
	mov  cx, bx    ; thick_2
	call draw_rect ; draw_rect(x - thick, y + h, w + thick_2, thick_2);

	mov  di, r12w  ; x - thick
	mov  si, r13w  ; y
	mov  dx, bx    ; thick_2
	mov  cx, r15w  ; h
	call draw_rect ; draw_rect(x - thick, y, thick_2, h);

	mov  si,   r13w ; y
	mov  dx,   bx   ; thick_2
	mov  cx,   r15w ; h
	sub  r14w, bx   ; w
	shr  bx,   1    ; thick
	mov  di,   r12w ; x - thick
	sub  di,   bx   ; x
	add  di,   r14w ; x + w
	call draw_rect  ; draw_rect(x + w, y, thick_2, h);

	pop rbx ; restore rbx
	pop r15 ; restore r15
	pop r14 ; restore r14
	pop r13 ; restore r13
	pop r12 ; restore r12

	pop rbp ; exiting the stack frame
	.nothing_to_draw:
	ret

; void draw_rect_line_ex_vec(ScreenVec2 pos, ScreeVec2 sizes, uint8_t thickness);
func(global, draw_rect_line_ex_vec)
	cmp dl, 0
	je  .nothing_to_draw
	cmp dl, 1
	je  draw_rect_line_vec

	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	mov r8b, dl ; r8b = thickness

	push rsi               ; push sizes
	push r8                ; push thickness
	call screenvec2_unpack ; screenvec2_unpack(pos);
	pop  r8                ; r8b = thickness
	pop  rdi               ; edi = sizes

	push r8  ; push thickness
	push rax ; push pos.x
	push rdx ; push pos.y

	sub  rsp, 8            ; to re-align the stack
	call screenvec2_unpack ; screenvec2_unpack(sizes);
	add  rsp, 8

	mov cx, dx ; cx = sizes.y
	mov dx, ax ; dx = sizes.x
	pop rsi    ; si = pos.y
	pop rdi    ; di = pos.x
	pop r8     ; r8b = thickness

	pop rbp               ; exiting the stack frame
	jmp draw_rect_line_ex

	.nothing_to_draw:
	ret

; void draw_triangle(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c);
func(global, draw_triangle)
	lea rcx, [put_pixel]
	jmp triangle_fill_algo_vec

; void draw_triangle_line(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c);
func(global, draw_triangle_line)
	lea rcx, [put_pixel]
	jmp triangle_line_algo_vec

; void draw_triangle_line_ex(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, uint8_t thickness);
func(global, draw_triangle_line_ex)
	cmp cl, 0
	je  .nothing_to_draw
	cmp cl, 1
	je  draw_triangle_line

	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15

	mov r12, rdi ; r12 = a
	mov r13, rsi ; r13 = b
	mov r14, rdx ; r14 = c
	mov r15, rcx ; r15 = thickness
	
	mov  rdx, r15     ; rdx = thickness
	call draw_line_ex ; draw_line_ex(a, b, thickness);

	mov  rdi, r13     ; rdi = b
	mov  rsi, r14     ; rsi = c
	mov  rdx, r15     ; rdx = thickness
	call draw_line_ex ; draw_line_ex(b, c, thickness);

	mov  rdi, r12     ; rdi = a
	mov  rsi, r14     ; rsi = c
	mov  rdx, r15     ; rdx = thickness
	call draw_line_ex ; draw_line_ex(b, c, thickness);

	pop r15 ; restore r15
	pop r14 ; restore r14
	pop r13 ; restore r13
	pop r12 ; restore r12

	pop rbp ; exiting the stack frame
	.nothing_to_draw:
	ret

; void draw_circle(uint16_t x, uint16_t y, uint8_t r);
func(global, draw_circle)
	lea rcx, [put_pixel]
	jmp circle_fill_algo

; void draw_circle_vec(ScreenVec2 pos, uint8_t r);
func(global, draw_circle_vec)
	lea rdx, [put_pixel]
	jmp circle_fill_algo_vec

; void draw_circle_line(uint16_t x, uint16_t y, uint8_t r);
func(global, draw_circle_line)
	lea rcx, [put_pixel]
	jmp circle_line_algo ; circle_line_algo(x, y, r, put_pixel);

; void draw_circle_line_vec(ScreenVec2 pos, uint8_t r);
func(global, draw_circle_line_vec)
	lea rdx, [put_pixel]
	jmp circle_line_algo_vec ; circle_line_algo_vec(pos, r, put_pixel);

; void draw_line(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY);
func(global, draw_line)
	lea r8, [put_pixel]
	jmp line_algo

; void draw_line_vec(ScreenVec2 a, ScreenVec2 b);
func(global, draw_line_vec)
	lea rdx, [put_pixel]
	jmp line_algo_vec

; void draw_line_ex_cb(uint16_t x, uint16_t y);
func(static, draw_line_ex_cb)
	mov dl, uint8_p [draw_line_ex_radius]
	jmp draw_circle

; void draw_line_ex(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, uint8_t thickness);
func(global, draw_line_ex)
	cmp r8b, 0
	je  .nothing_to_draw
	cmp r8b, 1
	je  draw_line

	mov uint8_p [draw_line_ex_radius], r8b
	
	lea  r8, [draw_line_ex_cb]
	call line_algo

	.nothing_to_draw:
	ret

; void draw_line_ex_vec(ScreenVec2 a, ScreenVec2 b, uint8_t thickness);
func(global, draw_line_ex_vec)
	push rbp      ; setting up the stack frame
	mov  rbp, rsp

	mov r8b, dl ; r8b = thickness

	push rsi               ; push b
	push r8                ; push thickness
	call screenvec2_unpack ; screenvec2_unpack(a);
	pop  r8                ; r8b = thickness
	pop  rdi               ; edi = b

	push r8  ; push thickness
	push rax ; push a.x
	push rdx ; push a.y

	sub  rsp, 8            ; to re-align the stack
	call screenvec2_unpack ; screenvec2_unpack(b);
	add  rsp, 8

	mov cx, dx ; cx = b.y
	mov dx, ax ; dx = b.x
	pop rsi    ; si = a.y
	pop rdi    ; di = a.x
	pop r8     ; r8b = thickness

	pop rbp ; exiting the stack frame

	jmp draw_line_ex
