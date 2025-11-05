%ifndef TEXTURE_INC
%define TEXTURE_INC

%include "engine/bitmap.inc"

; Texture formal definition
struc Texture
    ; The pixels array
    ; uint8_t* pixels;
    struc_member(pointer_t, pixels, 1)

	; Width of the pixels array
	; uint16_t width;
	struc_member(uint16_t, width, 1)

	; Height of the pixels array
	; uint16_t height;
	struc_member(uint16_t, height, 1)

	; Flag to tell if a certain color should be considered "blank"
	; bool has_blank;
	struc_member(bool_t, has_blank, 1)

	; This color will be treated as "blank" (not displayed) if 'has_blank' is true 
	; uint8_t has_blank;
	struc_member(uint8_t, blank, 1)

    .padding: resb 2 ; Padding to make the struct 16 bytes
endstruc

; uint8_t texture_get_pixel(const Texture* tex, uint16_t x, uint16_t y);
extern texture_get_pixel

; uint8_t texture_get_pixel_vec(const Texture* tex, ScreenVec2 pos);
extern texture_get_pixel_vec

; uint8_t texture_get_pixel_indexed(const Texture* tex, uint32_t idx);
extern texture_get_pixel_indexed

; void texture_set_pixel(Texture* tex, uint16_t x, uint16_t y, uint8_t col);
extern texture_set_pixel

; void texture_set_pixel_vec(Texture* tex, ScreenVec2 pos, uint8_t col);
extern texture_set_pixel_vec

; void texture_set_pixel_indexed(Texture* tex, uint32_t idx, uint8_t col);
extern texture_set_pixel_indexed

; void draw_texture(const Texture* tex, uint16_t x, uint16_t y);
extern draw_texture

; void draw_texture_vec(const Texture* tex, ScreenVec2 pos);
extern draw_texture_vec

; void draw_texture_rec(const Texture* tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_rec

; void draw_texture_rec_vec(const Texture* tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_rec_vec

; void draw_texture_masked(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y);
extern draw_texture_masked

; void draw_texture_masked_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos);
extern draw_texture_masked_vec

; void draw_texture_masked_rec(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_masked_rec

; void draw_texture_masked_rec_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_masked_rec_vec

%endif ; TEXTURE_INC
