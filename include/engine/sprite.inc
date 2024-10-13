%ifndef SPRITE_INC
%define SPRITE_INC

%include "engine/screen.inc"

struc Sprite
	.width:  resd 1
	.height: resd 1
	.pixels: ; should be a width * height array of bytes
endstruc

struc SpriteAtlas
	.pixel_width:    resd 1
	.pixel_height:   resd 1
	.sprite_width:   resd 1
	.sprite_height:  resd 1
	.sprite_count_x: resd 1
	.sprite_count_y: resd 1
	.pixels: ; should be a pixel_width * pixel_height array of bytes
endstruc

; args : Sprite* sprite, u16 x, u16 y
extern draw_sprite

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_x, u16 repeat_y
extern draw_sprite_repeat

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_x
extern draw_sprite_repeat_x

; args : Sprite* sprite, u16 x, u16 y, u16 repeat_y
extern draw_sprite_repeat_y

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY
extern draw_sprite_atlas

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_x, u16 repeat_y
extern draw_sprite_atlas_repeat

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_x
extern draw_sprite_atlas_repeat_x

; args : SpriteAtlas* atlas, u16 posX, u16 posY, u32 spriteX, u32 spriteY, u16 repeat_y
extern draw_sprite_atlas_repeat_y

%endif ; SPRITE_INC
