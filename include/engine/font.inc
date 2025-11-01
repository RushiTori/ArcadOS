%ifndef FONT_INC
%define FONT_INC

%include "engine/display.inc"

; args : u8 color
extern set_font_color

; args : u8 color
extern set_font_shadow_color

; args : u8 color
extern set_font_background_color

; args : u8 color, u8 shadow_color, u8 bg_color
extern set_font_colors

; args : u16 x, u16 y, u8 glyph
extern draw_glyph

; args : u16 x, u16 y, u8 glyph
extern draw_glyph_shadow

; args : u16 x, u16 y, u8 glyph
extern draw_glyph_background

; args : u16 x, u16 y, u8* text
extern draw_text

; args : u16 x, u16 y, u8* text
extern draw_text_shadow

; args : u16 x, u16 y, u8* text
extern draw_text_background

%endif ; FONT_INC
