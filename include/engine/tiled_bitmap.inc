%ifndef TILED_BITMAP_INC
%define TILED_BITMAP_INC

%include "engine/display.inc"

; TiledBitmap formal definition
struc TiledBitmap
    ; The bitTiles array, each tile is an 8x8 bits map and each uint64_t in this array contains a single tile
    ; uint64_t* bitTiles;
    struc_member(pointer_t, bitTiles, 1)

	; Width of the bitTiles array
	; uint16_t width;
	struc_member(uint16_t, width, 1)

	; Height of the bitTiles array
	; uint16_t height;
	struc_member(uint16_t, height, 1)

    .padding: resb 4 ; Padding to make the struct 16 bytes
endstruc

;
; draw tiled bitmap
; draw tiled bitmap vec
; draw tiled bitmap indexed
; draw tiled bitmap indexed vec
;

%endif ; TILED_BITMAP_INC
