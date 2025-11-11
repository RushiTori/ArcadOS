%ifndef SCREEN_INC
%define SCREEN_INC

%include "LuLib/lutypes.inc"
%include "engine/colors.inc"

%define SCREEN_WIDTH       320
%define SCREEN_HEIGHT      200
%define VGA_MEMORY_ADDR 0xA0000 ;0x4000000 
%define VGA_MEMORY_SIZE    (SCREEN_WIDTH * SCREEN_HEIGHT)

%define SCREEN_TILE_SIZE   8
%define SCREEN_TILE_WIDTH  (SCREEN_WIDTH / SCREEN_TILE_SIZE)
%define SCREEN_TILE_HEIGHT (SCREEN_HEIGHT / SCREEN_TILE_SIZE)

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
%define SCREEN_WIDTH    320
%define SCREEN_HEIGHT   200
%define VGA_MEMORY_SIZE (SCREEN_WIDTH * SCREEN_HEIGHT)

%endif ; SCREEN_INC
