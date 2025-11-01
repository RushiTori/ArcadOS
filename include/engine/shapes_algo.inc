%ifndef SHAPES_ALGO_INC
%define SHAPES_ALGO_INC

%include "engine/shapes_algo_base.inc"

;
;Callback types
;
;typedef void (*ShapeAlgoCall)(uint16_t x, uint16_t y);
;typedef bool (*ShapeAlgoCondCall)(uint16_t x, uint16_t y);
;

; void line_algo(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call);
extern line_algo

; ScreenVec2 line_algo_cond(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCondCall call);
extern line_algo_cond

; void line_algo_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call);
extern line_algo_vec

; ScreenVec2 line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCondCall call);
extern line_algo_cond_vec

; void rect_fill_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
extern rect_fill_algo

; ScreenVec2 rect_fill_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
extern rect_fill_algo_cond

; void rect_fill_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
extern rect_fill_algo_vec

; ScreenVec2 rect_fill_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
extern rect_fill_algo_cond_vec

; void rect_line_algo(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call);
extern rect_line_algo

; ScreenVec2 rect_line_algo_cond(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCondCall call);
extern rect_line_algo_cond

; void rect_line_algo_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call);
extern rect_line_algo_vec

; ScreenVec2 rect_line_algo_cond_vec(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCondCall call);
extern rect_line_algo_cond_vec

; void triangle_fill_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
extern triangle_fill_algo_vec

; ScreenVec2 triangle_fill_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
extern triangle_fill_algo_cond_vec

; void triangle_line_algo_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call);
extern triangle_line_algo_vec

; ScreenVec2 triangle_line_algo_cond_vec(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCondCall call);
extern triangle_line_algo_cond_vec

; void circle_line_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
extern circle_line_algo

; ScreenVec2 circle_line_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
extern circle_line_algo_cond

; void circle_line_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
extern circle_line_algo_vec

; ScreenVec2 circle_line_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
extern circle_line_algo_cond_vec

; void circle_fill_algo(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call);
extern circle_fill_algo

; ScreenVec2 circle_fill_algo_cond(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCondCall call);
extern circle_fill_algo_cond

; void circle_fill_algo_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call);
extern circle_fill_algo_vec

; ScreenVec2 circle_fill_algo_cond_vec(ScreenVec2 pos, uint8_t r, ShapeAlgoCondCall call);
extern circle_fill_algo_cond_vec

%endif ; SHAPES_ALGO_INC
