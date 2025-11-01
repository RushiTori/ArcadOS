%ifndef SHAPES_ALGO_BASE_INC
%define SHAPES_ALGO_BASE_INC

; Here "SreenVec2?" means that the return value is optional, based on "isCond"

; SreenVec2? line_algo_base(uint16_t aX, uint16_t aY, uint16_t bX, uint16_t bY, ShapeAlgoCall call, bool isCond);
extern line_algo_base

; SreenVec2? rect_fill_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
extern rect_fill_algo_base

; SreenVec2? rect_line_algo_base(uint16_t x, uint16_t y, uint16_t w, uint16_t h, ShapeAlgoCall call, bool isCond);
extern rect_line_algo_base

; SreenVec2? triangle_fill_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
extern triangle_fill_algo_base

; SreenVec2? triangle_line_algo_base(ScreenVec2 a, ScreenVec2 b, ScreenVec2 c, ShapeAlgoCall call, bool isCond);
extern triangle_line_algo_base

; SreenVec2? circle_fill_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_fill_algo_base

; SreenVec2? circle_line_algo_base(uint16_t x, uint16_t y, uint8_t r, ShapeAlgoCall call, bool isCond);
extern circle_line_algo_base

%endif ; SHAPES_ALGO_BASE_INC
