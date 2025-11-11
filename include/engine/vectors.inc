%ifndef VECTORS_INC
%define VECTORS_INC

%include "LuLib/lutypes.inc"

; ScreenVec2 formal definition
struc ScreenVec2
	; Vector x component
	; float x;
	struc_member(uint16_t, x, 1)

	; Vector y component
	; float y;
	struc_member(uint16_t, y, 1)
endstruc

; ScreenVec2 as a lutype
	define_type(ScreenVec2, d, dword)

; ScreenVec2 screenvec2_pack(uint16_t x, uint16_t y);
extern screenvec2_pack

; ScreenVec2 screenvec2_unpack(ScreenVec2 vec);
; ax: x
; dx: y
extern screenvec2_unpack

; ScreenVec2 screenvec2_screen_to_tile(ScreenVec2 screenPos);
extern screenvec2_screen_to_tile

; ScreenVec2 screenvec2_tile_to_screen(ScreenVec2 tilePos);
extern screenvec2_tile_to_screen

%endif ; VECTORS_INC
