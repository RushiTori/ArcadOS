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

; uint8_t bitmap_get_bit(const Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_get_bit)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Bitmap.width] ; eax = (uint32_t)(map->width)
    mul   edx                                ; eax = y * map->width
    add   esi, eax                           ; esi = y * map->width + x
    jmp   bitmap_get_bit_indexed             ; bitmap_get_bit_indexed(map, y * map->width + x);

; uint8_t bitmap_get_bit_vec(const Bitmap* map, ScreenVec2 pos);
func(global, bitmap_get_bit_vec)
    push rdi ; preserve map

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore map

    mov si, ax         ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    jmp bitmap_get_bit ; bitmap_get_bit(map, pos.x, pos.y);

; uint8_t bitmap_get_bit_indexed(const Bitmap* map, uint32_t idx);
func(global, bitmap_get_bit_indexed)
    mov rdi, pointer_p [rdi + Bitmap.pixels] ; rdi = map->pixels
    and rsi, 0xFFFFFFFF                      ; rsi = (uint64_t)idx

    mov al, uint8_p [rdi + rsi] ; al = map->pixels[(uint64_t)idx];
    ret

; void bitmap_set_bit(const Bitmap* map, uint16_t x, uint16_t y, uint8_t col);
func(global, bitmap_set_bit)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Bitmap.width] ; eax = (uint32_t)(map->width)
    mul   edx                                ; eax = y * map->width
    add   esi, eax                           ; esi = y * map->width + x
    jmp   bitmap_set_bit_indexed             ; bitmap_set_bit_indexed(map, y * map->width + x, col);

; void bitmap_set_bit_vec(const Bitmap* map, ScreenVec2 pos, uint8_t col);
func(global, bitmap_set_bit_vec)
    push rdx    ; preserve col
    push rdi    ; preserve map
    sub  rsp, 8 ; to re-align the stack

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    add rsp, 8 ; to re-align the stack
    pop rdi    ; restore map

    mov si, ax         ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    pop rcx            ; restore col
    jmp bitmap_set_bit ; bitmap_set_bit(map, pos.x, pos.y, col);

; void bitmap_set_bit_indexed(const Bitmap* map, uint32_t idx, uint8_t col);
func(global, bitmap_set_bit_indexed)
    mov rdi, pointer_p [rdi + Bitmap.pixels] ; rdi = map->pixels
    and rsi, 0xFFFFFFFF                      ; rsi = (uint64_t)idx

    mov uint8_p [rdi + rsi], dl ; map->pixels[(uint64_t)idx] = col;
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


; void draw_bitmap(const Bitmap* map, uint16_t x, uint16_t y);
func(global, draw_bitmap)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = y
    mov pointer_p [map],         rdi ; (static) map = (arg) map

    mov uint16_p [map_pos.x], 0 ; map_pos.x = 0
    mov uint16_p [map_pos.y], 0 ; map_pos.y = 0

    mov dx, uint16_p [rdi + Bitmap.width]  ; w = map->width
    mov cx, uint16_p [rdi + Bitmap.height] ; h = map->height
    xor di, di                             ; x = 0
    xor si, si                             ; y = 0
    lea r8, [put_bitmap_bit]               ; call = put_bitmap_bit
    jmp rect_fill_algo                     ; rect_fill_algo(0, 0, map->width, map->height, put_bitmap_bit);

; void draw_bitmap_vec(const Bitmap* map, ScreenVec2 pos);
func(global, draw_bitmap_vec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    push rdi ; preserve map

    mov  edi, esi
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore map

    mov si, ax ; x = pos.x
    ; mov dx, dx       ; y = pos.y

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = pos.y
    mov pointer_p [map],         rdi ; (static) map = (arg) map

    mov uint16_p [map_pos.x], 0 ; map_pos.x = 0
    mov uint16_p [map_pos.y], 0 ; map_pos.y = 0

    mov dx, uint16_p [rdi + Bitmap.width]  ; w = map->width
    mov cx, uint16_p [rdi + Bitmap.height] ; h = map->height
    xor di, di                             ; x = 0
    xor si, si                             ; y = 0
    lea r8, [put_bitmap_bit]               ; call = put_bitmap_bit
    jmp rect_fill_algo                     ; rect_fill_algo(0, 0, map->width, map->height, put_bitmap_bit);

; void draw_bitmap_rec(const Bitmap* map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_rec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = y
    mov pointer_p [map],         rdi ; (static) map = (arg) map

    mov ScreenVec2_p [map_pos], ecx ; map_pos = sourcePos

    mov edi, ecx              ; pos = sourcePos
    mov esi, r8d              ; sizes = sourceSizes
    lea rdx, [put_bitmap_bit] ; call = put_bitmap_bit
    jmp rect_fill_algo_vec    ; rect_fill_algo_vec(sourcePos, sourceSizes, put_bitmap_bit);

; void draw_bitmap_rec_vec(const Bitmap* map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_rec_vec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    push rdi ; preserve map
    push rdx ; preserve sourcePos
    push rcx ; preserve sourceSizes

    mov  edi, esi
    call screenvec2_unpack ; screenvec2_unpack(pos);

    mov si, ax ; x = pos.x
    ; mov dx, dx ; y = pos.y
    pop r8     ; restore sourceSizes
    pop rcx    ; restore sourcePos
    pop rdi    ; restore map

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = pos.y
    mov pointer_p [map],         rdi ; (static) map = (arg) map

    mov ScreenVec2_p [map_pos], ecx ; map_pos = sourcePos

    mov edi, ecx              ; pos = sourcePos
    mov esi, r8d              ; sizes = sourceSizes
    lea rdx, [put_bitmap_bit] ; call = put_bitmap_bit
    jmp rect_fill_algo_vec    ; rect_fill_algo_vec(sourcePos, sourceSizes, put_bitmap_bit);

; void draw_bitmap_masked(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_bitmap_masked)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si, dx
    mov dx, cx
    jmp draw_bitmap.ignore_no_mask ; draw_bitmap(map, x, y);

; void draw_bitmap_masked_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_bitmap_masked_vec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    jmp draw_bitmap_vec.ignore_no_mask ; draw_bitmap_vec(map, ScreenVec2 pos);

; void draw_bitmap_masked_rec(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si,  dx
    mov dx,  cx
    mov ecx, r8d
    mov r8d, r9d
    jmp draw_bitmap_rec.ignore_no_mask ; draw_bitmap_rec(map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);

; void draw_bitmap_masked_rec_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec_vec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    mov edx, ecx
    mov ecx, r8d
    jmp draw_bitmap_rec_vec.ignore_no_mask ; draw_bitmap_rec_vec(map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
