bits        64

%include "engine/font.inc"

section     .bss

res(static, uint8_t, color_a)
res(static, uint8_t, color_b)
res(static, uint8_t, color_c)

section     .text

%macro __one_color_base_body__ 2
	push rdi ; preserve glyphs
	push rsi ; preserve x
	push rdx ; preserve y

	call %1                    ; %1();
	mov  uint8_p [color_a], al ; color_a = %1();

	pop rdx            ; restore y
	pop rsi            ; restore x
	pop rdi            ; restore glyphs
	lea rcx, [%2]      ; call = %2
	jmp draw_text_algo ; draw_text_algo(glyphs, x, y, %2);
%endmacro

%define __one_color_base_body(colCall, drawCall) __one_color_base_body__ colCall, drawCall

%macro __base_vec_and_jump_to 1
	push rdi ; preserve glyphs

	mov  rdi, rsi
	call screenvec2_unpack ; screenvec2_unpack(pos);

	pop rdi    ; restore glyphs
	mov si, ax ; pos.x
	; mov dx, dx    ; pos.y
	jmp %1     ; %1(glyphs, pos.x, pos.y);
%endmacro

%macro __one_color_base_c_body_with 1
	mov uint8_p [color_a], cl ; color_a = col();

	lea rcx, [%1]      ; call = %1
	jmp draw_text_algo ; draw_text_algo(glyphs, x, y, %1);
%endmacro

%macro __one_color_base_vec_c_body_and_jump_to 1
	push rdx    ; preserve col
	push rdi    ; preserve glyphs
	sub  rsp, 8 ; to re-align the stack

	mov  rdi, rsi
	call screenvec2_unpack ; screenvec2_unpack(pos);

	sub rsp, 8  ; to re-align the stack
	pop rdi     ; restore glyphs
	mov si,  ax ; pos.x
	; mov dx, dx    ; pos.y
	pop rcx     ; restore col
	jmp %1      ; %1(glyphs, pos.x, pos.y, col);
%endmacro

;
; typedef void (*DrawGlyphCB)(uint8_t glyph, uint16_t x, uint16_t y, uint8_t? colA, uint8_t? colB, uint8_t? colC);
;
; void draw_text_algo(const uint8_t* glyphs, uint16_t x, uint16_t y, DrawGlyphCB call);
func(static, draw_text_algo)
	;
	;uint16_t startX = x;
	;uint16_t currX = x;
	;uint16_t currY = y;
	;uint8_t currGlyph = *glyphs;
	;
	;while ((currGlyph = *glyphs++)) {
	;  if (currGlyph == FONT_LINE_FEED) goto handle_line_feed;
	;  if (currGlyph == FONT_CARRIAGE_RETURN) goto handle_carriage_return;
	;  if (currGlyph == FONT_HORIZONTAL_TAB) goto handle_horizontal_tab;
	;
	;  handle_drawing_glyph:
	;    call(currGlyph, currX, currY, color_a?, color_b?, color_c?);
	;    currX += FONT_TILE_WIDTH;
	;    goto finished_handling_glyph;
	;
	;  handle_line_feed:
	;    currY += FONT_TILE_HEIGHT;
	;    if (make_nl_as_crnl()) currX = startX;
	;    goto finished_handling_glyph;
	;
	;  handle_carriage_return:
	;    currX = startX;
	;    if (make_cr_as_crnl()) currY += FONT_TILE_HEIGHT;
	;    goto finished_handling_glyph;
	;
	;  handle_horizontal_tab:
	;    currX += FONT_TILE_WIDTH * get_tab_space
	;    goto finished_handling_glyph;
	;
	;  finished_handling_glyph:
	;}
	;
	;r12 = glyphs
	;r13w = currX
	;r14w = currY
	;r15w = startX
	;rbx = call
	;
	;al = currGlyph
	;

	push r12 ; preserve r12
	push r13 ; preserve r13
	push r14 ; preserve r14
	push r15 ; preserve r15
	push rbx ; preserve rbx

	mov r12,  rdi ; r12 = glyphs
	mov r13w, si  ; r13w = currX
	mov r14w, dx  ; r14w = currY
	mov r15w, si  ; r15w = startX
	mov rbx,  rcx ; rbx = call

	.algo_loop:
		mov al, uint8_p [r12] ; al = currGlyph
		cmp al, 0x00
		je  .algo_loop_end

		; if (currGlyph == FONT_LINE_FEED) goto handle_line_feed;
		cmp al, FONT_LINE_FEED
		je  .handle_line_feed

		; if (currGlyph == FONT_CARRIAGE_RETURN) goto handle_carriage_return;
		cmp al, FONT_CARRIAGE_RETURN
		je  .handle_carriage_return

		; if (currGlyph == FONT_HORIZONTAL_TAB) goto handle_horizontal_tab;
		cmp al, FONT_HORIZONTAL_TAB
		je  .handle_horizontal_tab

		; jmp handle_drawing_glyph

		.handle_drawing_glyph:
			mov  dil,  al                 ; currGlyph
			mov  si,   r13w               ; currX
			mov  dx,   r14w               ; currY
			mov  cl,   uint8_p [color_a]  ; cl = color_a
			mov  r8b,  uint8_p [color_b]  ; r8b = color_b
			mov  r9b,  uint8_p [color_c]  ; r9b = color_c
			call rbx                      ; call(currGlyph, currX, currY, color_a?, color_b?, color_c?);
			add  r13w, FONT_TILE_WIDTH    ; currX += FONT_TILE_WIDTH
			jmp  .finished_handling_glyph

		.handle_line_feed:
			add r14w, FONT_TILE_HEIGHT ; currY += FONT_TILE_HEIGHT

			call get_make_nl_as_crnl      ; get_make_nl_as_crnl();
			cmp  al, false
			jne  .finished_handling_glyph ; if (!get_make_nl_as_crnl()) continue

			mov r13w, r15w ; currX = startX

			jmp .finished_handling_glyph

		.handle_carriage_return:
			mov r13w, r15w ; currX = startX

			call get_make_cr_as_crnl      ; get_make_cr_as_crnl();
			cmp  al, false
			jne  .finished_handling_glyph ; if (!get_make_cr_as_crnl()) continue

			add r14w, FONT_TILE_HEIGHT ; currY += FONT_TILE_HEIGHT

			jmp .finished_handling_glyph

		.handle_horizontal_tab:
			call get_tab_space            ; get_tab_space();
			and  ax,   0xFF               ; ax = (uint16_t)get_tab_space();
			imul ax, ax, FONT_TILE_WIDTH ; ax = get_tab_space() * FONT_TILE_WIDTH
			add  r13w, ax                 ; currX += get_tab_space() * FONT_TILE_WIDTH
			jmp  .finished_handling_glyph

		.finished_handling_glyph:
			jmp .algo_loop
	.algo_loop_end:

	pop rbx ; restore rbx
	pop r15 ; restore r15
	pop r14 ; restore r14
	pop r13 ; restore r13
	pop r12 ; restore r12
	ret

; void draw_text(const uint8_t* glyphs, uint16_t x, uint16_t y);
func(global, draw_text)
	__one_color_base_body(get_font_color, draw_glyph_c)

; void draw_text_vec(const uint8_t* glyphs, ScreenVec2 pos);
func(global, draw_text_vec)
	__base_vec_and_jump_to draw_text

; void draw_text_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
func(global, draw_text_c)
	__one_color_base_c_body_with draw_glyph_c

; void draw_text_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
func(global, draw_text_c_vec)
	__one_color_base_vec_c_body_and_jump_to draw_text_c

; void draw_text_shadow(const uint8_t* glyphs, uint16_t x, uint16_t y);
func(global, draw_text_shadow)
	__one_color_base_body(get_font_color, draw_glyph_shadow_c)

; void draw_text_shadow_vec(const uint8_t* glyphs, ScreenVec2 pos);
func(global, draw_text_shadow_vec)
	__base_vec_and_jump_to draw_text_shadow

; void draw_text_shadow_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
func(global, draw_text_shadow_c)
	__one_color_base_c_body_with draw_glyph_shadow_c

; void draw_text_shadow_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
func(global, draw_text_shadow_c_vec)
	__one_color_base_vec_c_body_and_jump_to draw_text_shadow_c

; void draw_text_background(const uint8_t* glyphs, uint16_t x, uint16_t y);
func(global, draw_text_background)
	__one_color_base_body(get_font_color, draw_glyph_background_c)

; void draw_text_background_vec(const uint8_t* glyphs, ScreenVec2 pos);
func(global, draw_text_background_vec)
	__base_vec_and_jump_to draw_text_background

; void draw_text_background_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
func(global, draw_text_background_c)
	__one_color_base_c_body_with draw_glyph_background_c

; void draw_text_background_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
func(global, draw_text_background_c_vec)
	__one_color_base_vec_c_body_and_jump_to draw_text_background_c
