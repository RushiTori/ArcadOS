%ifndef SHAPES_ALGO_BASE_INC
%define SHAPES_ALGO_BASE_INC

%include "LuLib/lutypes.inc"

; Defined in shapee_algo.asm
; Contains the last pos evaluated by a shape algo base that "failed"
; extern ScreenVec2 shapes_algo_base_fail_pos;
extern shapes_algo_base_fail_pos

; bool line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
extern line_algo_base

; bool line_algo_base(ScreenVec2 a, ScreenVec2 b, ShapeAlgoCall call, bool isCond);
extern line_algo_vec_base

; bool rect_fill_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
extern rect_fill_algo_base

; bool rect_fill_algo_base(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call, bool isCond);
extern rect_fill_algo_vec_base

; bool rect_line_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
extern rect_line_algo_base

; bool rect_line_algo_base(ScreenVec2 pos, ScreenVec2 sizes, ShapeAlgoCall call, bool isCond);
extern rect_line_algo_vec_base

; bool triangle_fill_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
extern triangle_fill_algo_base

; bool triangle_line_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
extern triangle_line_algo_base

; bool circle_fill_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_fill_algo_base

; bool circle_fill_algo_base(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_fill_algo_vec_base

; bool circle_line_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_line_algo_base

; bool circle_line_algo_base(ScreenVec2 pos, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_line_algo_vec_base

%endif ; SHAPES_ALGO_BASE_INC
