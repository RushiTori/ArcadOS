bits    64

%include "engine/tiled_bitmap.inc"

section .rodata

tile_as_bitmap:
static  tile_as_bitmap: data
	istruc Bitmap
        at .bits,   dq tile_data
        at .width,  dw 8
        at .height, dw 8
        at .padding db 0, 0, 0, 0
	iend

section      .bss

res(static,  uint64_t, tile_data)

section      .text

; uint64_t tiled_bitmap_get_tile(const TiledBitmap* tile_map, uint16_t x, uint16_t y);
func(global, tiled_bitmap_get_tile)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + TiledBitmap.width] ; eax = (uint32_t)(tile_map->width)
    mul   edx                                     ; eax = y * tile_map->width
    add   esi, eax                                ; esi = y * tile_map->width + x
    jmp   tiled_bitmap_get_tile_indexed           ; tiled_bitmap_get_tile_indexed(tile_map, y * tile_map->width + x);

; uint64_t tiled_bitmap_get_tile_vec(const TiledBitmap* tile_map, ScreenVec2 pos);
func(global, tiled_bitmap_get_tile_vec)
    push rdi ; preserve tile_map

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore tile_map

    mov si, ax                ; si = pos.x
    ; mov dx, dx                ; dx = pos.y
    jmp tiled_bitmap_get_tile ; tiled_bitmap_get_tile(tile_map, pos.x, pos.y);

; uint64_t tiled_bitmap_get_tile_indexed(const TiledBitmap* tile_map, uint32_t idx);
func(global, tiled_bitmap_get_tile_indexed)
    mov rdi, pointer_p [rdi + TiledBitmap.tiles] ; rdi = tile_map->tiles
    and rsi, 0xFFFFFFFF                          ; rsi = (uint64_t)idx
    mov rax, uint64_p [rdi + rsi]                ; return tile_map->tiles[idx];
    ret

; void tiled_bitmap_set_tile(const TiledBitmap* tile_map, uint16_t x, uint16_t y, uint64_t tile);
func(global, tiled_bitmap_set_tile)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + TiledBitmap.width] ; eax = (uint32_t)(tile_map->width)
    mul   edx                                     ; eax = y * tile_map->width
    add   esi, eax                                ; esi = y * tile_map->width + x
    jmp   tiled_bitmap_set_tile_indexed           ; tiled_bitmap_set_tile_indexed(tile_map, y * tex->width + x, tile);

; void tiled_bitmap_set_tile_vec(const TiledBitmap* tile_map, ScreenVec2 pos, uint64_t tile);
func(global, tiled_bitmap_set_tile_vec)
    push rdx    ; preserve tile
    push rdi    ; preserve tile_map
    sub  rsp, 8 ; to re-align the stack

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    add rsp, 8 ; to re-align the stack
    pop rdi    ; restore tile_map

    mov si, ax                ; si = pos.x
    ; mov dx, dx                ; dx = pos.y
    pop rcx                   ; restore tile
    jmp tiled_bitmap_set_tile ; tiled_bitmap_set_tile(tile_map, pos.x, pos.y, tile);

; void tiled_bitmap_set_tile_indexed(const TiledBitmap* tile_map, uint32_t idx, uint64_t tile);
func(global, tiled_bitmap_set_tile_indexed)
    mov rdi,                  pointer_p [rdi + TiledBitmap.tiles] ; rdi = tile_map->tiles
    and rsi,                  0xFFFFFFFF                          ; rsi = (uint64_t)idx
    mov uint64_p [rdi + rsi], rdx                                 ; tile_map->tiles[idx] = tile;
    ret

; void draw_tiled_bitmap(const TiledBitmap* tile_map, uint16_t tileX, uint16_t tileY, uint16_t posX, uint16_t posY);
func(global, draw_tiled_bitmap)
    push rcx    ; preserve posY
    push rdx    ; preserve posX
    sub  rsp, 8 ; to re-align the stack

    call tiled_bitmap_get_tile ; tiled_bitmap_get_tile(tile_map, tileX, tileY);

    mov uint64_p [tile_data], rax ; tile_data = tiled_bitmap_get_tile(tile_map, tileX, tileY);

    lea rdi, [tile_as_bitmap] ; rdi = &tile_as_bitmap

    add rsp, 8      ; to re-align the stack
    pop rsi         ; restore posX
    pop rdx         ; restore posY
    jmp draw_bitmap ; draw_bitmap(&tile_as_bitmap, posX, posY);

; void draw_tiled_bitmap_vec(const TiledBitmap* tile_map, ScreenVec2 tilePos, ScreenVec2 screenPos);
func(global, draw_tiled_bitmap_vec)
    push rdx ; preserve screenPos

    call tiled_bitmap_get_tile_vec ; tiled_bitmap_get_tile_vec(tile_map, tilePos);

    pop rsi ; restore screenPos

    mov uint64_p [tile_data], rax ; tile_data = tiled_bitmap_get_tile_vec(tile_map, tilePos);

    lea rdi, [tile_as_bitmap] ; rdi = &tile_as_bitmap;

    jmp draw_bitmap_vec ; draw_bitmap_vec(&tile_as_bitmap, screenPos);

; void draw_tiled_bitmap_indexed(const TiledBitmap* tile_map, uint32_t idx, uint16_t posX, uint16_t posY);
func(global, draw_tiled_bitmap_indexed)
    push rcx    ; preserve posY
    push rdx    ; preserve posX
    sub  rsp, 8 ; to re-align the stack

    call tiled_bitmap_get_tile_indexed ; tiled_bitmap_get_tile_indexed(tile_map, idx);

    mov uint64_p [tile_data], rax ; tile_data = tiled_bitmap_get_tile_indexed(tile_map, idx);

    lea rdi, [tile_as_bitmap] ; rdi = &tile_as_bitmap

    add rsp, 8      ; to re-align the stack
    pop rsi         ; restore posX
    pop rdx         ; restore posY
    jmp draw_bitmap ; draw_bitmap(&tile_as_bitmap, posX, posY);

; void draw_tiled_bitmap_indexed_vec(const TiledBitmap* tile_map, uint32_t idx, ScreenVec2 screenPos);
func(global, draw_tiled_bitmap_indexed_vec)
    push rdx ; preserve screenPos

    call tiled_bitmap_get_tile_indexed_vec ; tiled_bitmap_get_tile_indexed_vec(tile_map, idx);

    pop rsi ; restore screenPos

    mov uint64_p [tile_data], rax ; tile_data = tiled_bitmap_get_tile_indexed(tile_map, idx);

    lea rdi, [tile_as_bitmap] ; rdi = &tile_as_bitmap;

    jmp draw_bitmap_vec ; draw_bitmap_vec(&tile_as_bitmap, screenPos);
