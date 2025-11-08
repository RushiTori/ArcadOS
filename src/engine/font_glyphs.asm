bits    64

%include "engine/font.inc"

section .data

current_font_data:
static  current_font_data: data
	istruc TiledBitmap
        at .tiles,         dq NULL
        at .width,         dw FONT_WIDTH
        at .height,        dw FONT_HEIGHT
        at .main_color,    db 0x0F
        at .inverse_color, db 0x00
        at .padding,       db 0, 0
	iend

section .text

%macro prepare_drawing_glyph_and_jump_to 1
	push rdi ; preserve glyph
	push rsi ; preserve x
	push rdx ; preserve y

	call get_current_font ; get_current_font();

	mov rax, pointer_p [rax + TiledBitmap.tiles] ; rax = get_current_font()->tiles

	mov pointer_p [current_font_data + TiledBitmap.tiles], rax ; current_font_data.tiles = get_current_font()->tiles

	pop rcx                      ; restore y
	pop rdx                      ; restore x
	pop rsi                      ; restore glyph
	and esi, 0xFF                ; esi = (uint32_t)glyph
	lea rdi, [current_font_data] ; rdi = &current_font_data
	jmp %1                       ; %1(&current_font_data, glyph, x, y);
%endmacro

%macro __base_body_and_jump_to 1
	push rdi ; preserve glyph
	push rsi ; preserve x
	push rdx ; preserve y

	call get_font_color ; get_font_color();

	mov cl, al ; cl = get_font_color();
	pop rdx    ; restore y
	pop rsi    ; restore x
	pop rdi    ; restore glyph
	jmp %1     ; %1(glyph, x, y, get_font_color());
%endmacro

%macro __base_vec_body_and_jump_to 1
	push rdi ; preserve glyph

	mov  rdi, rsi
	call screenvec2_unpack ; screenvec2_unpack(pos);

	pop rdi    ; restore glyph
	mov si, ax ; pos.x
	; mov dx, dx ; pos.y
	jmp %1     ; %1(glyph, pos.x, pos.y);
%endmacro

%macro __base_c_vec_body_and_jump_to 1
	push rdi    ; preserve glyph
	push rdx    ; preserve col
	sub  rsp, 8 ; to re-align the stack

	mov  rdi, rsi
	call screenvec2_unpack ; screenvec2_unpack(pos);

	add rsp, 8  ; to re-align the stack
	pop rcx     ; restore col
	pop rdi     ; restore glyph
	mov si,  ax ; pos.x
	mov dx,  dx ; pos.y
	jmp %1      ; %1(glyph, pos.x, pos.y, col);
%endmacro

; void draw_glyph_base(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(static, draw_glyph_base)
	mov uint8_p [current_font_data.main_color], cl ; current_font_data.main_color = col

	prepare_drawing_glyph_and_jump_to draw_tiled_bitmap_indexed

; void draw_glyph(uint8_t glyph, uint16_t x, uint16_t y);
func(global, draw_glyph)
	__base_body_and_jump_to draw_glyph_base

; void draw_glyph_vec(uint8_t glyph, ScreenVec2 pos);
func(global, draw_glyph_vec)
	__base_vec_body_and_jump_to draw_glyph

; void draw_glyph_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(global, draw_glyph_c)
	jmp draw_glyph_base ; draw_glyph_base(glyph, x, y, col);

; void draw_glyph_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
func(global, draw_glyph_c_vec)
	__base_c_vec_body_and_jump_to draw_glyph_base

; void draw_glyph_background_base(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(static, draw_glyph_background_base)
	mov uint8_p [current_font_data.inverse_color], cl ; current_font_data.inverse_color = col

	prepare_drawing_glyph_and_jump_to draw_tiled_bitmap_inverse_indexed

; void draw_glyph_background(uint8_t glyph, uint16_t x, uint16_t y);
func(draw_glyph_background)
	__base_body_and_jump_to draw_glyph_background_base

; void draw_glyph_background_vec(uint8_t glyph, ScreenVec2 pos);
func(draw_glyph_background_vec)
	__base_vec_body_and_jump_to draw_glyph_background

; void draw_glyph_background_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(draw_glyph_background_c)
	jmp draw_glyph_background_base ; draw_glyph_background_base(glyph, x, y, col);

; void draw_glyph_background_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
func(draw_glyph_background_c_vec)
	__base_c_vec_body_and_jump_to draw_glyph_background_base

; void draw_glyph_shadow_base(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(static, draw_glyph_shadow_base)
	mov uint8_p [current_font_data.main_color], cl ; current_font_data.main_color = col

	inc si ; x++
	inc dx ; y++

	prepare_drawing_glyph_and_jump_to draw_tiled_bitmap_inverse_indexed

; void draw_glyph_shadow(uint8_t glyph, uint16_t x, uint16_t y);
func(draw_glyph_shadow)
	__base_body_and_jump_to draw_glyph_shadow_base

; void draw_glyph_shadow_vec(uint8_t glyph, ScreenVec2 pos);
func(draw_glyph_shadow_vec)
	__base_vec_body_and_jump_to draw_glyph_shadow

; void draw_glyph_shadow_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
func(draw_glyph_shadow_c)
	jmp draw_glyph_shadow_base ; draw_glyph_shadow_base(glyph, x, y, col);

; void draw_glyph_shadow_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
func(draw_glyph_shadow_c_vec)
	__base_c_vec_body_and_jump_to draw_glyph_shadow_base
