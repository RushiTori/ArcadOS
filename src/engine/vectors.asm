bits    64
default rel

%include "engine/vectors.inc"

%define SUB_TILE_MASK 0b00000111_00000111

section      .text

; ScreenVec2 screenvec2_pack(uint16_t x, uint16_t y);
func(global, screenvec2_pack)
	xor eax, eax
	mov ax,  di
	shl esi, 16
	or  eax, esi
	ret

; ScreenVec2 screenvec2_unpack(ScreenVec2 vec);
; ax: x
; dx: y
func(global, screenvec2_unpack)
	mov ax,  di
	shr edi, 16
	mov dx,  di
	ret

; ScreenVec2 screenvec2_screen_to_tile(ScreenVec2 screenPos);
func(global, screenvec2_screen_to_tile)
	mov eax, edi
	and eax, ~(SUB_TILE_MASK) ; to make sure to not poison the upper 'x' value with the lower 'y' value
	shr eax, 3
	ret

; ScreenVec2 screenvec2_tile_to_screen(ScreenVec2 tilePos);
func(global, screenvec2_tile_to_screen)
	mov eax, edi
	and eax, ~(SUB_TILE_MASK << 5) ; to make sure to not poison the lower 'y' value with the upper 'x' value
	shl eax, 3
	ret
