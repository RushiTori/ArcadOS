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

; uint64_t tiled_bitmap_get_tile(const TiledBitmap* tile_map, uint16_t x, uint16_t y);
extern tiled_bitmap_get_tile

; uint64_t tiled_bitmap_get_tile_vec(const TiledBitmap* tile_map, ScreenVec2 pos);
extern tiled_bitmap_get_tile_vec

; uint64_t tiled_bitmap_get_tile_indexed(const TiledBitmap* tile_map, uint32_t idx);
extern tiled_bitmap_get_tile_indexed

; void tiled_bitmap_set_tile(const TiledBitmap* tile_map, uint16_t x, uint16_t y, uint64_t tile);
extern tiled_bitmap_set_tile

; void tiled_bitmap_set_tile_vec(const TiledBitmap* tile_map, ScreenVec2 pos, uint64_t tile);
extern tiled_bitmap_set_tile_vec

; void tiled_bitmap_set_tile_indexed(const TiledBitmap* tile_map, uint32_t idx, uint64_t tile);
extern tiled_bitmap_set_tile_indexed

; void draw_tiled_bitmap(const TiledBitmap* tile_map, uint16_t tileX, uint16_t tileY, uint16_t posX, uint16_t posY);
extern draw_tiled_bitmap

; void draw_tiled_bitmap_vec(const TiledBitmap* tile_map, ScreenVec2 tilePos, ScreenVec2 screenPos);
extern draw_tiled_bitmap_vec

; void draw_tiled_bitmap_indexed(const TiledBitmap* tile_map, uint32_t idx, uint16_t posX, uint16_t posY);
extern draw_tiled_bitmap_indexed

; void draw_tiled_bitmap_indexed_vec(const TiledBitmap* tile_map, uint32_t idx, ScreenVec2 screenPos);
extern draw_tiled_bitmap_indexed_vec

%endif ; TILED_BITMAP_INC
