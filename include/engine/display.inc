%ifndef DISPLAY_INC
%define DISPLAY_INC

%include "engine/font.inc"

; args : u8 color
extern set_color

; args : 
extern clear_screen

; args : u16 x, u16 y
extern put_pixel

; args : u16 x, u16 y, u16 size
extern draw_square

; args : u16 x, u16 y, u16 w, u16 h
extern draw_rect

; args : u16 x, u16 y, u16 size
extern draw_square_line

; args : u16 x, u16 y, u16 w, u16 h
extern draw_rect_line

; args : u16 x, u16 y, u16 size, u16 thickness
extern draw_square_line_ex

; args : u16 x, u16 y, u16 w, u16 h, u16 thickness
extern draw_rect_line_ex

; args : u16 x0, u16 y0, u16 x1, u16 y1
extern draw_line

; args : u16 x, u16 y, u16 radius
extern draw_circle

; args : u16 x, u16 y, u16 radius
extern draw_circle_line

%endif ; DISPLAY_INC
