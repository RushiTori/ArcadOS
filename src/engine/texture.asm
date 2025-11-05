bits        64

%include "texture.inc"

section     .bss

res(static, pointer_t, source_pixels)
res(static, pointer_t, mask_pixels)
res(static, pointer_t, mask_bits)

screen_pos:
static      screen_pos: data
	istruc ScreenVec2
		at .x, resw 1
		at .y, resw 1
	iend

res(static,  bool_t, use_mask)

section      .text

; void put_texture_pixel(uint16_t x, uint16_t y);
func(static, put_texture_pixel)
    ; WIP
    ret

; void draw_texture(const Texture* tex, uint16_t x, uint16_t y);
func(global, draw_texture)
    mov uint8_p [use_mask], false ; no masking to be done
    .ignore_no_mask:

    mov uint16_p [screen_pos.x],   si                               ; screen_pos.x = x
    mov uint16_p [screen_pos.y],   dx                               ; screen_pos.y = y
    mov rax,                       pointer_p [rdi + Texture.pixels] ; rax = tex->pixels
    mov pointer_p [source_pixels], rax                              ; source_pixels = tex->pixels

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

    mov uint16_p [screen_pos.x],   si                               ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y],   dx                               ; screen_pos.y = pos.y
    mov rax,                       pointer_p [rdi + Texture.pixels] ; rax = tex->pixels
    mov pointer_p [source_pixels], rax                              ; source_pixels = tex->pixels

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

    mov uint16_p [screen_pos.x],   si                               ; screen_pos.x = x
    mov uint16_p [screen_pos.y],   dx                               ; screen_pos.y = y
    mov rax,                       pointer_p [rdi + Texture.pixels] ; rax = tex->pixels
    mov pointer_p [source_pixels], rax                              ; source_pixels = tex->pixels

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

    mov uint16_p [screen_pos.x],   si                               ; screen_pos.x = pos.x
    mov uint16_p [screen_pos.y],   dx                               ; screen_pos.y = pos.y
    mov rax,                       pointer_p [rdi + Texture.pixels] ; rax = tex->pixels
    mov pointer_p [source_pixels], rax                              ; source_pixels = tex->pixels

    mov edi, ecx                 ; pos = sourcePos
    mov esi, r8d                 ; sizes = sourceSizes
    lea rdx, [put_texture_pixel] ; call = put_texture_pixel
    jmp rect_fill_algo_vec       ; rect_fill_algo_vec(sourcePos, sourceSizes, put_texture_pixel);

; void draw_texture_masked(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y);
func(global, draw_texture_masked)
    mov uint8_p [mask_type], PIXEL_MASK ; masking done with a texture

    ; Shifting registers to mimmick a call without mask
    mov si, dx
    mov dx, cx
    jmp draw_texture.ignore_no_mask ; draw_texture(tex, x, y);

; void draw_texture_masked_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos);
func(global, draw_texture_masked_vec)
    mov uint8_p [mask_type], PIXEL_MASK ; masking done with a texture

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    jmp draw_texture_vec.ignore_no_mask ; draw_texture_vec(tex, ScreenVec2 pos);

; void draw_texture_masked_rec(const Texture* tex, const Bitmap* mask, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec)
    mov uint8_p [mask_type], PIXEL_MASK ; masking done with a texture

    ; Shifting registers to mimmick a call without mask
    mov si,  dx
    mov dx,  cx
    mov ecx, r8d
    mov r8d, r9d
    jmp draw_texture_rec.ignore_no_mask ; draw_texture_rec(tex, uint16_t x, uint16_t y, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);

; void draw_texture_masked_rec_vec(const Texture* tex, const Bitmap* mask, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
func(global, draw_texture_masked_rec_vec)
    mov uint8_p [mask_type], PIXEL_MASK ; masking done with a texture

    ; Shifting registers to mimmick a call without mask
    mov esi, edx
    mov edx, ecx
    mov ecx, r8d
    jmp draw_texture_rec_vec.ignore_no_mask ; draw_texture_rec_vec(tex, ScreenVec2 pos, ScreenVec2 sourcePos, ScreenVec2 sourceSizes);
