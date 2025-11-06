bits        64

%include "engine/bitmap.inc"

section     .bss

res(static, pointer_t, map)
res(static, pointer_t, mask)

screen_pos:
static      screen_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

map_pos:
static map_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

res(static,  bool_t, use_mask)

section      .text

; void put_bitmap_bit(uint16_t x, uint16_t y);
func(static, put_bitmap_bit)
    ;
    ; uint16_t screenX = x - map_pos.x + screen_pos.x;
    ; uint16_t screenY = y - map_pos.y + screen_pos.y;
    ;
    ; bool isMapBitSet = bitmap_get_bit(map, x, y);
    ;
    ; bool canPut = !usemask || (use_mask && bitmap_get_bit(mask, x, y));
    ;
    ; if (canPut) put_pixel(screenX, screenY);
    ;
    ; WIP

    sub rsp,                8  ; make enough space for: x and y
    mov uint16_p [rsp],     di ; preserve x
    mov uint16_p [rsp + 2], si ; preserve y

    mov al, bool_p [use_mask]
    cmp al, false
    je  .skip_check_mask      ; if (use_mask)
        mov  dx,  si               ; dx = y
        mov  si,  di               ; si = x
        mov  rdi, pointer_p [mask] ; rdi = mask
        call bitmap_get_bit        ; bitmap_get_bit(mask, x, y);
        
        cmp al, false
        je  .end      ; if (!bitmap_get_bit(mask, x, y)) return;

        mov di, uint16_p [rsp]     ; restore x
        mov si, uint16_p [rsp + 2] ; restore y
    .skip_check_mask:

    mov  dx,  si              ; dx = y
    mov  si,  di              ; si = x
    mov  rdi, pointer_p [map] ; rdi = map
    call bitmap_get_bit       ; bitmap_get_bit(map, x, y);
    cmp  al,  false
    je   .end

    mov di,  uint16_p [rsp]     ; restore x
    mov si,  uint16_p [rsp + 2] ; restore y
    add rsp, 8                  ; to exit the stack frame
    
    sub di, uint16_p [map_pos.x]    ; di = x - map_pos.x
    add di, uint16_p [screen_pos.x] ; di = x - map_pos.x + screen_pos.x

    sub si, uint16_p [map_pos.y]    ; si = y - map_pos.y
    add si, uint16_p [screen_pos.y] ; si = y - map_pos.y + screen_pos.y

    jmp put_pixel ; put_pixel_c(screenX, screenY);

    .end:
    add rsp, 8 ; to exit the stack frame
    ret

; void bitmap_get_bit(const Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_get_bit)
    ; WIP
    ret

; void bitmap_get_bit_vec(const Bitmap* map, ScreenVec2 pos);
func(global, bitmap_get_bit_vec)
    ; WIP
    ret

; void bitmap_get_bit_indexed(const Bitmap* map, uint32_t idx);
func(global, bitmap_get_bit_indexed)
    ; WIP
    ret

; void bitmap_set_bit(Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_set_bit)
    ; WIP
    ret

; void bitmap_set_bit_vec(Bitmap* map, ScreenVec2 pos);
func(global, bitmap_set_bit_vec)
    ; WIP
    ret

; void bitmap_set_bit_indexed(Bitmap* map, uint32_t idx);
func(global, bitmap_set_bit_indexed)
    ; WIP
    ret

; void draw_bitmap(const Bitmap* map, uint16_t x, uint16_t y);
func(global, draw_bitmap)
    ; WIP
    ret

; void draw_bitmap_vec(const Bitmap* map, ScreenVec2 pos);
func(global, draw_bitmap_vec)
    ; WIP
    ret

; void draw_bitmap_rec(const Bitmap* map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_rec)
    ; WIP
    ret

; void draw_bitmap_rec_vec(const Bitmap* map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_rec_vec)
    ; WIP
    ret

; void draw_bitmap_masked(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_bitmap_masked)
    ; WIP
    ret

; void draw_bitmap_masked_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_bitmap_masked_vec)
    ; WIP
    ret

; void draw_bitmap_masked_rec(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec)
    ; WIP
    ret

; void draw_bitmap_masked_rec_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec_vec)
    ; WIP
    ret
