%ifndef DISPLAY_INC
%define DISPLAY_INC

%include "engine/screen.inc"
%include "engine/shapes_algo.inc"

%define DISPLAY_WIDTH       SCREEN_WIDTH
%define DISPLAY_HEIGHT      SCREEN_HEIGHT
%define DISPLAY_BUFFER_SIZE (DISPLAY_WIDTH * DISPLAY_HEIGHT)

; pointer_t get_display_buffer(void);
extern get_display_buffer

; void set_display_buffer(pointer_t buffer);
extern set_display_buffer

; uint8_t get_display_color(void);
extern get_display_color

; void set_display_color(uint8_t col);
extern set_display_color

; void put_pixel(uint16_t x, uint16_t y);
extern put_pixel

; void put_pixel_c(uint16_t x, uint16_t y, uint8_t col);
extern put_pixel_c

; void put_pixel_vec(ScreenVec2 pos);
extern put_pixel_vec

; void put_pixel_c_vec(ScreenVec2 pos, uint8_t col);
extern put_pixel_c_vec

; void clear_screen(void);
extern clear_screen

; void clear_screen_c(uint8_t col);
extern clear_screen_c

; void draw_square(uint16_t x, uint16_t y, uint16_t size);
extern draw_square

; void draw_square_vec(ScreenVec2 pos, uint16_t size);
extern draw_square_vec

; void draw_square_line(uint16_t x, uint16_t y, uint16_t size);
extern draw_square_line

; void draw_square_line_vec(ScreenVec2 pos, uint16_t size);
extern draw_square_line_vec

; void draw_square_line_ex(uint16_t x, uint16_t y, uint16_t size, uint8_t thickness);
extern draw_square_line_ex

; void draw_square_line_ex_vec(ScreenVec2 pos, uint16_t size, uint8_t thickness);
extern draw_square_line_ex_vec

; void draw_rect(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
extern draw_rect

; void draw_rect_vec(ScreenVec2 pos, ScreeVec2 sizes);
extern draw_rect_vec

; void draw_rect_line(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
extern draw_rect_line

; void draw_rect_line_vec(ScreenVec2 pos, ScreeVec2 sizes);
extern draw_rect_line_vec

; void draw_rect_line_ex(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t thickness);
extern draw_rect_line_ex

; void draw_rect_line_ex_vec(ScreenVec2 pos, ScreeVec2 sizes, uint8_t thickness);
extern draw_rect_line_ex_vec

; void draw_triangle(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c);
extern draw_triangle

; void draw_triangle_line(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c);
extern draw_triangle_line

; void draw_triangle_line_ex(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, uint8_t thickness);
extern draw_triangle_line_ex

; void draw_circle(uint16_t x, uint16_t y, uint8_t r);
extern draw_circle

; void draw_circle_vec(ScreenVec2 pos, uint8_t r);
extern draw_circle_vec

; void draw_circle_line(uint16_t x, uint16_t y, uint8_t r);
extern draw_circle_line

; void draw_circle_line_vec(ScreenVec2 pos, uint8_t r);
extern draw_circle_line_vec

; void draw_line(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY);
extern draw_line

; void draw_line_vec(ScreenVec2 a, ScreenVec2 b);
extern draw_line_vec

; void draw_line_ex(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, uint8_t thickness);
extern draw_line_ex

; void draw_line_ex_vec(ScreenVec2 a, ScreenVec2 b, uint8_t thickness);
extern draw_line_ex_vec

%endif ; DISPLAY_INC
