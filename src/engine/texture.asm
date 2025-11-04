bits 64

%include "texture.inc"

section .bss

res(static, pointer_t, source_pixels)
res(static, pointer_t, mask_pixels)
res(static, pointer_t, mask_bits)

screen_pos:
static      screen_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

; enum MaskType: uint8_t
    reset_enum_value(0)
    add_enum(NO_MASK)
    add_enum(PIXEL_MASK)
    add_enum(BIT_MASK)

res(static, uint8_t, mask_type)

section .text

; void put_texture_pixel(uint16_t x, uint16_t y);
func(static, put_texture_pixel)
    ; WIP
    ret

; void draw_texture(const Texture* tex, uint16_t x, uint16_t y);
func(global, draw_texture)
    ; WIP
    ret

; void draw_texture_vec(const Texture* tex, ScreenVec2 pos);
func(global, draw_texture_vec)
    ; WIP
    ret

; void draw_texture_rec(const Texture* tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_rec)
    ; WIP
    ret

; void draw_texture_rec_vec(const Texture* tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_rec_vec)
    ; WIP
    ret

; void draw_texture_masked(const Texture* tex, const Texture* mask, uint16_t x, uint16_t y);
func(global, draw_texture_masked)
    ; WIP
    ret

; void draw_texture_masked_vec(const Texture* tex, const Texture* mask, ScreenVec2 pos);
func(global, draw_texture_masked_vec)
    ; WIP
    ret

; void draw_texture_masked_rec(const Texture* tex, const Texture* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec)
    ; WIP
    ret

; void draw_texture_masked_rec_vec(const Texture* tex, const Texture* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec_vec)
    ; WIP
    ret

; void draw_texture_bitmasked(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_texture_bitmasked)
    ; WIP
    ret

; void draw_texture_bitmasked_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_texture_bitmasked_vec)
    ; WIP
    ret

; void draw_texture_bitmasked_rec(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_bitmasked_rec)
    ; WIP
    ret

; void draw_texture_bitmasked_rec_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_bitmasked_rec_vec)
    ; WIP
    ret
