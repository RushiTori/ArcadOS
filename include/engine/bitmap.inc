%ifndef BITMAP_INC
%define BITMAP_INC

%include "engine/display.inc"

; Bitmap formal definition
struc Bitmap
    ; The bits array, each byte contains 8 bits
    ; uint8_t* bits;
    struc_member(pointer_t, bits, 1)

	; Width of the bits array
	; uint16_t width;
	struc_member(uint16_t, width, 1)

	; Height of the bits array
	; uint16_t height;
	struc_member(uint16_t, height, 1)

    .padding: resb 4 ; Padding to make the struct 16 bytes
endstruc

;
;bitmap get bit
;bitmap get bit vec
;bitmap get bit indexed
;bitmap set bit
;bitmap set bit vec
;bitmap set bit indexed
;bitmap unset bit
;bitmap unset bit vec
;bitmap unset bit indexed
;draw bitmap
;draw bitmap vec
;draw bitmap rec
;draw bitmap rec vec
;draw bitmap masked
;draw bitmap masked vec
;draw bitmap masked rec
;draw bitmap masked rec vec
;

; bool_t bitmap_get_bit(const Bitmap* map, uint16_t x, uint16_t y);
extern bitmap_get_bit

; bool_t bitmap_get_bit_vec(const Bitmap* map, ScreenVec2 pos);
extern bitmap_get_bit_vec

; bool_t bitmap_get_bit_indexed(const Bitmap* map, uint32_t idx);
extern bitmap_get_bit_indexed

; void bitmap_set_bit(Bitmap* map, uint16_t x, uint16_t y);
extern bitmap_set_bit

; void bitmap_set_bit_vec(Bitmap* map, ScreenVec2 pos);
extern bitmap_set_bit_vec

; void bitmap_set_bit_indexed(Bitmap* map, uint32_t idx);
extern bitmap_set_bit_indexed

; void bitmap_unset_bit(Bitmap* map, uint16_t x, uint16_t y);
extern bitmap_unset_bit

; void bitmap_unset_bit_vec(Bitmap* map, ScreenVec2 pos);
extern bitmap_unset_bit_vec

; void bitmap_unset_bit_indexed(Bitmap* map, uint32_t idx);
extern bitmap_unset_bit_indexed

; void draw_bitmap(const Bitmap* map, uint16_t x, uint16_t y);
extern draw_bitmap

; void draw_bitmap_vec(const Bitmap* map, ScreenVec2 pos);
extern draw_bitmap_vec

; void draw_bitmap_rec(const Bitmap* map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_bitmap_rec

; void draw_bitmap_rec_vec(const Bitmap* map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_bitmap_rec_vec

; void draw_bitmap_masked(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y);
extern draw_bitmap_masked

; void draw_bitmap_masked_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos);
extern draw_bitmap_masked_vec

; void draw_bitmap_masked_rec(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_bitmap_masked_rec

; void draw_bitmap_masked_rec_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
extern draw_bitmap_masked_rec_vec

%endif ; BITMAP_INC
