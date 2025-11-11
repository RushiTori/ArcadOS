bits        64

%include "engine/bitmap.inc"

section     .bss

res(static, pointer_t, map)
res(static, pointer_t, mask)

screen_pos:
static      screen_pos: data
	istruc ScreenVec2
		at ScreenVec2.x, .x: resw 1
		at ScreenVec2.y, .y: resw 1
	iend

map_pos:
static map_pos: data
	istruc ScreenVec2
		at ScreenVec2.x, .x: resw 1
		at ScreenVec2.y, .y: resw 1
	iend

res(static,  bool_t, use_mask)
res(static,  bool_t, inversed)

section      .text

; void put_bitmap_bit(uint16_t x, uint16_t y);
func(static, put_bitmap_bit)
    ;
    ; uint16_t screenX = x - map_pos.x + screen_pos.x;
    ; uint16_t screenY = y - map_pos.y + screen_pos.y;
    ; uint8_t col = (inversed)? map->inverse_color : map->main_color;
    ;
    ; bool isMapBitSet = bitmap_get_bit(map, x, y);
    ;
    ; bool canPut = !usemask || (use_mask && (bitmap_get_bit(mask, x, y) ^ inversed));
    ;
    ; if (canPut) put_pixel(screenX, screenY);
    ;

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

    mov  dx,  si                ; dx = y
    mov  si,  di                ; si = x
    mov  rdi, pointer_p [map]   ; rdi = map
    call bitmap_get_bit         ; bitmap_get_bit(map, x, y);
    xor  al,  bool_p [inversed] ; bitmap_get_bit(map, x, y) ^ inversed
    cmp  al,  false
    je   .end

    mov di,  uint16_p [rsp]     ; restore x
    mov si,  uint16_p [rsp + 2] ; restore y
    add rsp, 8                  ; to exit the stack frame
    
    sub di, uint16_p [map_pos.x]    ; di = x - map_pos.x
    add di, uint16_p [screen_pos.x] ; di = x - map_pos.x + screen_pos.x

    sub si, uint16_p [map_pos.y]    ; si = y - map_pos.y
    add si, uint16_p [screen_pos.y] ; si = y - map_pos.y + screen_pos.y

    mov rdx,               pointer_p [map]           ; rdx = map
    mov dl,                [rdx + Bitmap.main_color] ; dl = map->main_color
    cmp bool_p [inversed], false
    je  .skip_load_inverse_col
        mov dl, [rdx + Bitmap.inverse_color] ; if (inversed) dl = map->inverse_color
    .skip_load_inverse_col:

    jmp put_pixel_c ; put_pixel_c(screenX, screenY, col);

    .end:
    add rsp, 8 ; to exit the stack frame
    ret

; bool_t bitmap_get_bit(const Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_get_bit)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Bitmap.width] ; eax = (uint32_t)(map->width)
    mul   edx                                ; eax = y * map->width
    add   esi, eax                           ; esi = y * map->width + x
    jmp   bitmap_get_bit_indexed             ; bitmap_get_bit_indexed(map, y * map->width + x);

; bool_t bitmap_get_bit_vec(const Bitmap* map, ScreenVec2 pos);
func(global, bitmap_get_bit_vec)
    push rdi ; preserve map

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore map

    mov si, ax         ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    jmp bitmap_get_bit ; bitmap_get_bit(map, pos.x, pos.y);

; bool_t bitmap_get_bit_indexed(const Bitmap* map, uint32_t idx);
func(global, bitmap_get_bit_indexed)
    ;
    ; uint32_t byteIdx = idx / 8;
    ; uint8_t bitIdx = idx % 8;
    ; uint8_t bitMask = 1 << bitIdx;
    ; bool_t res = (bool_t)(map->bits[byteIdx] & bitMask);
    ;

    mov esi, esi   ; rsi = (uint64_t)idx
    mov rdx, rsi   ; rdx = (uint64_t)idx
    and rdx, 0b111 ; rdx = bitIdx
    shr rsi, 3     ; rsi = byteIdx

    mov rdi, pointer_p [rdi + Bitmap.bits] ; rdi = map->bits
    mov al,  uint8_p [rdi + rsi]           ; al = map->bits[(uint64_t)idx];

    mov   cl, dl
    mov   dl, 1
    shl   dl, cl ; dl = bitMask
    and   al, dl ; al = map->bits[byteIdx] & bitMask
    setnz al     ; al = (bool_t)(map->bits[byteIdx] & bitMask)
    ret

; void bitmap_set_bit(const Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_set_bit)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Bitmap.width] ; eax = (uint32_t)(map->width)
    mul   edx                                ; eax = y * map->width
    add   esi, eax                           ; esi = y * map->width + x
    jmp   bitmap_set_bit_indexed             ; bitmap_set_bit_indexed(map, y * map->width + x, col);

; void bitmap_set_bit_vec(const Bitmap* map, ScreenVec2 pos);
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

; void bitmap_set_bit_indexed(const Bitmap* map, uint32_t idx);
func(global, bitmap_set_bit_indexed)
    ;
    ; uint32_t byteIdx = idx / 8;
    ; uint8_t bitIdx = idx % 8;
    ; uint8_t bitMask = 1 << bitIdx;
    ; map->bits[byteIdx] = map->bits[byteIdx] | bitMask;
    ;

    mov esi, esi   ; rsi = (uint64_t)idx
    mov rdx, rsi   ; rdx = (uint64_t)idx
    and rdx, 0b111 ; rdx = bitIdx
    shr rsi, 3     ; rsi = byteIdx

    mov rdi, pointer_p [rdi + Bitmap.bits] ; rdi = map->bits
    mov al,  uint8_p [rdi + rsi]           ; al = map->bits[(uint64_t)idx];

    mov cl, dl
    mov dl, 1
    shl dl, cl ; dl = bitMask
    or  al, dl ; al = map->bits[byteIdx] | bitMask
    
    mov uint8_p [rdi + rsi], al ; map->bits[byteIdx] = map->bits[byteIdx] | bitMask
    ret

; void bitmap_unset_bit(const Bitmap* map, uint16_t x, uint16_t y);
func(global, bitmap_unset_bit)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Bitmap.width] ; eax = (uint32_t)(map->width)
    mul   edx                                ; eax = y * map->width
    add   esi, eax                           ; esi = y * map->width + x
    jmp   bitmap_unset_bit_indexed           ; bitmap_unset_bit_indexed(map, y * map->width + x, col);

; void bitmap_unset_bit_vec(const Bitmap* map, ScreenVec2 pos);
func(global, bitmap_unset_bit_vec)
    push rdx    ; preserve col
    push rdi    ; preserve map
    sub  rsp, 8 ; to re-align the stack

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    add rsp, 8 ; to re-align the stack
    pop rdi    ; restore map

    mov si, ax           ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    pop rcx              ; restore col
    jmp bitmap_unset_bit ; bitmap_unset_bit(map, pos.x, pos.y, col);

; void bitmap_unset_bit_indexed(const Bitmap* map, uint32_t idx);
func(global, bitmap_unset_bit_indexed)
    ;
    ; uint32_t byteIdx = idx / 8;
    ; uint8_t bitIdx = idx % 8;
    ; uint8_t bitMask = ~(1 << bitIdx);
    ; map->bits[byteIdx] = map->bits[byteIdx] & bitMask;
    ;

    mov esi, esi   ; rsi = (uint64_t)idx
    mov rdx, rsi   ; rdx = (uint64_t)idx
    and rdx, 0b111 ; rdx = bitIdx
    shr rsi, 3     ; rsi = byteIdx

    mov rdi, pointer_p [rdi + Bitmap.bits] ; rdi = map->bits
    mov al,  uint8_p [rdi + rsi]           ; al = map->bits[(uint64_t)idx];

    mov cl, dl
    mov dl, 1
    shl dl, cl ; dl = 1 << bitIdx
    not dl     ; dl = bitMask
    and al, dl ; al = map->bits[byteIdx] & bitMask
    
    mov uint8_p [rdi + rsi], al ; map->bits[byteIdx] = map->bits[byteIdx] & bitMask
    ret

; void draw_bitmap(const Bitmap* map, uint16_t x, uint16_t y);
func(global, draw_bitmap)
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
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
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
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
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
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
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
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
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
    mov pointer_p [mask],   rsi   ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true  ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si, dx
    mov dx, cx
    jmp draw_bitmap.ignore_no_mask ; draw_bitmap(map, x, y);

; void draw_bitmap_masked_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_bitmap_masked_vec)
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
    mov pointer_p [mask],   rsi   ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true  ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    jmp draw_bitmap_vec.ignore_no_mask ; draw_bitmap_vec(map, ScreenVec2 pos);

; void draw_bitmap_masked_rec(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec)
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
    mov pointer_p [mask],   rsi   ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true  ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si,  dx
    mov dx,  cx
    mov ecx, r8d
    mov r8d, r9d
    jmp draw_bitmap_rec.ignore_no_mask ; draw_bitmap_rec(map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);

; void draw_bitmap_masked_rec_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_masked_rec_vec)
    mov bool_p [inversed],  false ; not inversed
    .ignore_no_inverse:
    mov pointer_p [mask],   rsi   ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true  ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    mov edx, ecx
    mov ecx, r8d
    jmp draw_bitmap_rec_vec.ignore_no_mask ; draw_bitmap_rec_vec(map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);

; void draw_bitmap_inversed(const Bitmap* map, uint16_t x, uint16_t y);
func(global, draw_bitmap_inversed)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap.ignore_no_inverse ; draw_bitmap(map, x, y);

; void draw_bitmap_inversed_vec(const Bitmap* map, ScreenVec2 pos);
func(global, draw_bitmap_inversed_vec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_vec.ignore_no_inverse ; draw_bitmap_vec(map, pos);

; void draw_bitmap_inversed_rec(const Bitmap* map, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_inversed_rec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_rec.ignore_no_inverse ; draw_bitmap_rec(map, x, y, sourcePos, sourceSizes);

; void draw_bitmap_inversed_rec_vec(const Bitmap* map, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_inversed_rec_vec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_rec_vec.ignore_no_inverse ; draw_bitmap_rec_vec(map, pos, sourcePos, sourceSizes);

; void draw_bitmap_inversed_masked(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_bitmap_inversed_masked)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_masked.ignore_no_inverse ; draw_bitmap_masked(map, mask, x, y);

; void draw_bitmap_inversed_masked_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_bitmap_inversed_masked_vec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_masked_vec.ignore_no_inverse ; draw_bitmap_masked_vec(map, mask, pos);

; void draw_bitmap_inversed_masked_rec(const Bitmap* map, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_inversed_masked_rec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_masked_rec.ignore_no_inverse ; draw_bitmap_masked_rec(map, mask, x, y, sourcePos, sourceSizes);

; void draw_bitmap_inversed_masked_rec_vec(const Bitmap* map, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_bitmap_inversed_masked_rec_vec)
    mov bool_p [inversed], true ; inversed = true

    jmp draw_bitmap_masked_rec_vec.ignore_no_inverse ; draw_bitmap_masked_rec_vec(map, mask, pos, sourcePos, sourceSizes);
