bits 64

%include "engine/sprite.inc"

section .text

; args : u8* screen_addr, u8 pixels[n], u16 n
pixels_memcpy:
static pixels_memcpy:function
	.cpy_loop:
		lodsb
		cmp al, COLOR_BLANK
		je .skip_put_pixel
		stosb
		jmp .skip_inc_pixels
		.skip_put_pixel:
		inc rsi
		.skip_inc_pixels:
		dec rdx
		jnz .cpy_loop
	.end:
	ret

; args : u8 pixels[width * height], u16 x, u16 y, u16 width, u16 height
draw_pixels_array:
static draw_pixels_array:function
	; WIP
	and rsi, 0xFFFF
	and rdx, 0xFFFF
	cmp rsi, SCREEN_WIDTH
	jae .end
	cmp rdx, SCREEN_HEIGHT
	jae .end

	and rcx, 0xFFFF
	and r8, 0xFFFF

	mov r9, SCREEN_HEIGHT
	sub r9, rdx
	cmp r9, r8
	jbe .skip_min_y
	mov r9, r8
	.skip_min_y:
	mov r8, r9

	mov r9, SCREEN_WIDTH
	sub r9, rsi
	cmp r9, rcx
	jbe .skip_min_x
	mov r9, rcx
	.skip_min_x:
	sub rcx, r9

	imul rdx, SCREEN_WIDTH
	add rsi, rdx
	add rsi, VGA_MEMORY_ADDR

	xchg rdi, rsi

	.draw_loop:
		cmp r8, 0
		je .end
		mov rdx, r9
		call pixels_memcpy
		add rsi, rcx
		sub rdi, r9
		add rdi, SCREEN_WIDTH
		dec r8
		jmp .draw_loop
	.end:
	ret

; args : Sprite* sprite, u16 x, u16 y
draw_sprite:
global draw_sprite:function
	; WIP
	ret

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_x, u16 repeat_y
draw_sprite_repeat:
global draw_sprite_repeat:function
	; WIP
	ret

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_x
draw_sprite_repeat_x:
global draw_sprite_repeat_x:function
	; WIP
	ret

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_y
draw_sprite_repeat_y:
global draw_sprite_repeat_y:function
	; WIP
	ret

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY
draw_sprite_atlas:
global draw_sprite_atlas:function
	; WIP
	ret

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_x, u16 repeat_y
draw_sprite_atlas_repeat:
global draw_sprite_atlas_repeat:function
	; WIP
	ret

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_x
draw_sprite_atlas_repeat_x:
global draw_sprite_atlas_repeat_x:function
	; WIP
	ret

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_y
draw_sprite_atlas_repeat_y:
global draw_sprite_atlas_repeat_y:function
	; WIP
	ret
