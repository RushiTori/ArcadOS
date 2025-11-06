%ifndef TILED_BITMAP_INC
%define TILED_BITMAP_INC

%include "engine/display.inc"

; TiledBitmap formal definition
struc TiledBitmap
    ; The tiles array, each tile is an 8x8 Bitmap and each uint64_t in this array contains a single tile
    ; uint64_t* tiles;
    struc_member(pointer_t, tiles, 1)

	; Width of the tiles array
	; uint16_t width;
	struc_member(uint16_t, width, 1)

	; Height of the tiles array
	; uint16_t height;
	struc_member(uint16_t, height, 1)

    .padding: resb 4 ; Padding to make the struct 16 bytes
endstruc

; void tiled_bitmap_get_tile(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_get_tile

; void tiled_bitmap_get_tile_vec(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_get_tile_vec

; void tiled_bitmap_get_tile_indexed(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_get_tile_indexed

; void tiled_bitmap_set_tile(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_set_tile

; void tiled_bitmap_set_tile_vec(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_set_tile_vec

; void tiled_bitmap_set_tile_indexed(const TiledBitmap* tile_map, WIP);
extern tiled_bitmap_set_tile_indexed

; void draw_tiled_bitmap(const TiledBitmap* tile_map, WIP);
extern draw_tiled_bitmap

; void draw_tiled_bitmap_vec(const TiledBitmap* tile_map, WIP);
extern draw_tiled_bitmap_vec

; void draw_tiled_bitmap_indexed(const TiledBitmap* tile_map, WIP);
extern draw_tiled_bitmap_indexed

; void draw_tiled_bitmap_indexed_vec(const TiledBitmap* tile_map, WIP);
extern draw_tiled_bitmap_indexed_vec

%endif ; TILED_BITMAP_INC
