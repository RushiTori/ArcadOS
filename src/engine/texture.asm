bits        64

%include "texture.inc"

section     .bss

res(static, pointer_t, tex)
res(static, pointer_t, mask)

screen_pos:
static      screen_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

tex_pos:
static tex_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

res(static,  bool_t, use_mask)

section      .text

; void put_texture_pixel(uint16_t x, uint16_t y);
func(static, put_texture_pixel)
    ;
    ; uint16_t screenX = x - tex_pos.x + screen_pos.x;
    ; uint16_t screenY = y - tex_pos.y + screen_pos.y;
    ;
    ; uint8_t texCol = texture_get_pixel(tex, x, y);
    ;
    ; put_pixel_c(screenX, screenY, texCol);
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

    mov  dx,  si              ; dx = y
    mov  si,  di              ; si = x
    mov  rdi, pointer_p [tex] ; rdi = tex
    call texture_get_pixel    ; texture_get_pixel(tex, x, y);

    mov di,  uint16_p [rsp]     ; restore x
    mov si,  uint16_p [rsp + 2] ; restore y
    add rsp, 8                  ; to exit the stack frame
    
    sub di, uint16_p [tex_pos.x]    ; di = x - tex_pos.x
    add di, uint16_p [screen_pos.x] ; di = x - tex_pos.x + screen_pos.x

    sub si, uint16_p [tex_pos.y]    ; si = y - tex_pos.y
    add si, uint16_p [screen_pos.y] ; si = y - tex_pos.y + screen_pos.y

    mov dl, al ; dl = texture_get_pixel(tex, x, y);

    jmp put_pixel_c ; put_pixel_c(screenX, screenY, texCol);

    .end:
    add rsp, 8 ; to exit the stack frame
    ret

; uint8_t texture_get_pixel(const Texture* tex, uint16_t x, uint16_t y);
func(global, texture_get_pixel)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Texture.width] ; eax = (uint32_t)(tex->width)
    mul   edx                                 ; eax = y * tex->width
    add   esi, eax                            ; esi = y * tex->width + x
    jmp   texture_get_pixel_indexed           ; texture_get_pixel_indexed(tex, y * tex->width + x);

; uint8_t texture_get_pixel_vec(const Texture* tex, ScreenVec2 pos);
func(global, texture_get_pixel_vec)
    push rdi ; preserve tex

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore tex

    mov si, ax            ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    jmp texture_get_pixel ; texture_get_pixel(tex, pos.x, pos.y);

; uint8_t texture_get_pixel_indexed(const Texture* tex, uint32_t idx);
func(global, texture_get_pixel_indexed)
    mov rdi, pointer_p [rdi + Texture.pixels] ; rdi = tex->pixels
    and rsi, 0xFFFFFFFF                       ; rsi = (uint64_t)idx

    mov al, uint8_p [rdi + rsi] ; al = tex->pixels[(uint64_t)idx];
    ret

; void texture_set_pixel(const Texture* tex, uint16_t x, uint16_t y, uint8_t col);
func(global, texture_set_pixel)
    and esi, 0xFFFF ; esi = (uint32_t)x
    and edx, 0xFFFF ; edx = (uint32_t)y

    movzx eax, uint16_p [rdi + Texture.width] ; eax = (uint32_t)(tex->width)
    mul   edx                                 ; eax = y * tex->width
    add   esi, eax                            ; esi = y * tex->width + x
    jmp   texture_set_pixel_indexed           ; texture_set_pixel_indexed(tex, y * tex->width + x, col);

; void texture_set_pixel_vec(const Texture* tex, ScreenVec2 pos, uint8_t col);
func(global, texture_set_pixel_vec)
    push rdx    ; preserve col
    push rdi    ; preserve tex
    sub  rsp, 8 ; to re-align the stack

    mov  edi, esi          ; edi = pos
    call screenvec2_unpack ; screenvec2_unpack(pos);

    add rsp, 8 ; to re-align the stack
    pop rdi    ; restore tex

    mov si, ax            ; si = pos.x
    ; mov dx, dx            ; dx = pos.y
    pop rcx               ; restore col
    jmp texture_set_pixel ; texture_set_pixel(tex, pos.x, pos.y, col);

; void texture_set_pixel_indexed(const Texture* tex, uint32_t idx, uint8_t col);
func(global, texture_set_pixel_indexed)
    mov rdi, pointer_p [rdi + Texture.pixels] ; rdi = tex->pixels
    and rsi, 0xFFFFFFFF                       ; rsi = (uint64_t)idx

    mov uint8_p [rdi + rsi], dl ; tex->pixels[(uint64_t)idx] = col;
    ret

; void draw_texture(const Texture* tex, uint16_t x, uint16_t y);
func(global, draw_texture)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = y
    mov pointer_p [tex],         rdi ; (static) tex = (arg) tex

    mov uint16_p [tex_pos.x], 0 ; tex_pos.x = 0
    mov uint16_p [tex_pos.y], 0 ; tex_pos.y = 0

    mov dx, uint16_p [rdi + Texture.width]  ; w = tex->width
    mov cx, uint16_p [rdi + Texture.height] ; h = tex->height
    xor di, di                              ; x = 0
    xor si, si                              ; y = 0
    lea r8, [put_texture_pixel]             ; call = put_texture_pixel
    jmp rect_fill_algo                      ; rect_fill_algo(0, 0, tex->width, tex->height, put_texture_pixel);

; void draw_texture_vec(const Texture* tex, ScreenVec2 pos);
func(global, draw_texture_vec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    push rdi ; preserve tex

    mov  edi, esi
    call screenvec2_unpack ; screenvec2_unpack(pos);

    pop rdi ; restore tex

    mov si, ax ; x = pos.x
    ; mov dx, dx       ; y = pos.y

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = pos.y
    mov pointer_p [tex],         rdi ; (static) tex = (arg) tex

    mov uint16_p [tex_pos.x], 0 ; tex_pos.x = 0
    mov uint16_p [tex_pos.y], 0 ; tex_pos.y = 0

    mov dx, uint16_p [rdi + Texture.width]  ; w = tex->width
    mov cx, uint16_p [rdi + Texture.height] ; h = tex->height
    xor di, di                              ; x = 0
    xor si, si                              ; y = 0
    lea r8, [put_texture_pixel]             ; call = put_texture_pixel
    jmp rect_fill_algo                      ; rect_fill_algo(0, 0, tex->width, tex->height, put_texture_pixel);

; void draw_texture_rec(const Texture* tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_rec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = y
    mov pointer_p [tex],         rdi ; (static) tex = (arg) tex

    mov ScreenVec2_p [tex_pos], ecx ; tex_pos = sourcePos

    mov edi, ecx                 ; pos = sourcePos
    mov esi, r8d                 ; sizes = sourceSizes
    lea rdx, [put_texture_pixel] ; call = put_texture_pixel
    jmp rect_fill_algo_vec       ; rect_fill_algo_vec(sourcePos, sourceSizes, put_texture_pixel);

; void draw_texture_rec_vec(const Texture* tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_rec_vec)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    push rdi ; preserve tex
    push rdx ; preserve sourcePos
    push rcx ; preserve sourceSizes

    mov  edi, esi
    call screenvec2_unpack ; screenvec2_unpack(pos);

    mov si, ax ; x = pos.x
    ; mov dx, dx ; y = pos.y
    pop r8     ; restore sourceSizes
    pop rcx    ; restore sourcePos
    pop rdi    ; restore tex

    mov uint16_p [screen_pos.x], si  ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y], dx  ; screen_pos.y = pos.y
    mov pointer_p [tex],         rdi ; (static) tex = (arg) tex

    mov ScreenVec2_p [tex_pos], ecx ; tex_pos = sourcePos

    mov edi, ecx                 ; pos = sourcePos
    mov esi, r8d                 ; sizes = sourceSizes
    lea rdx, [put_texture_pixel] ; call = put_texture_pixel
    jmp rect_fill_algo_vec       ; rect_fill_algo_vec(sourcePos, sourceSizes, put_texture_pixel);

; void draw_texture_masked(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_texture_masked)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si, dx
    mov dx, cx
    jmp draw_texture.ignore_no_mask ; draw_texture(tex, x, y);

; void draw_texture_masked_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_texture_masked_vec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    jmp draw_texture_vec.ignore_no_mask ; draw_texture_vec(tex, ScreenVec2 pos);

; void draw_texture_masked_rec(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov si,  dx
    mov dx,  cx
    mov ecx, r8d
    mov r8d, r9d
    jmp draw_texture_rec.ignore_no_mask ; draw_texture_rec(tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);

; void draw_texture_masked_rec_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec_vec)
    mov pointer_p [mask],   rsi  ; (static) mask = (arg) mask
    mov uint8_p [use_mask], true ; there is masking to be done

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    mov edx, ecx
    mov ecx, r8d
    jmp draw_texture_rec_vec.ignore_no_mask ; draw_texture_rec_vec(tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
