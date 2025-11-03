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

;
; Maybe add masked versions ???
; Bitmap (2D or contiguous ?)
; Font could be a contiguous Bitmap ?
; maybe add both bitmap types to accomodate everyone ?
; maybe add masking with texture and 2D bitmaps too ?
;
;
;
;draw texture
;draw texture vec
;draw texture rec
;draw texture rec vec
;draw texture masked
;draw texture masked vec
;draw texture masked rec
;draw texture masked rec vec
;

; void draw_texture(const Texture* tex, uint16_t x, uint16_t y);
extern draw_texture

; void draw_texture_vec(const Texture* tex, ScreenVec2 pos);
extern draw_texture_vec

; void draw_texture_rec(const Texture* tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_rec

; void draw_texture_rec_vec(const Texture* tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_rec_vec

; void draw_texture_masked(const Texture* tex, const Texture* mask, uint16_t x, uint16_t y);
extern draw_texture_masked

; void draw_texture_masked_vec(const Texture* tex, const Texture* mask, ScreenVec2 pos);
extern draw_texture_masked_vec

; void draw_texture_masked_rec(const Texture* tex, const Texture* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_masked_rec

; void draw_texture_masked_rec_vec(const Texture* tex, const Texture* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_masked_rec_vec

; void draw_texture_bitmasked(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y);
extern draw_texture_bitmasked

; void draw_texture_bitmasked_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos);
extern draw_texture_bitmasked_vec

; void draw_texture_bitmasked_rec(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_bitmasked_rec

; void draw_texture_bitmasked_rec_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_texture_bitmasked_rec_vec

%endif ; TEXTURE_INC
