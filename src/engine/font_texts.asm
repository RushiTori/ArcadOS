bits         64

%include "engine/font.inc"

section      .text

;
; typedef void (*DrawGlyphCB)(uint8_t glyph, uint16_t x, uint16_t y);
;
; void draw_text_algo(const uint8_t* glyphs, uint16_t x, uint16_t y, DrawGlyphCB call);
func(static, draw_text_algo)
	;
	;uint16_t startX = x;
	;uint16_t currX = x;
	;uint16_t currY = y;
	;uint8_t currGlyph = *glyphs;
	;
	;while ((currGlyph = *glyphs++)) {
	;  if (currGlyph == FONT_LINE_FEED) goto handle_line_feed;
	;  if (currGlyph == FONT_CARRIAGE_RETURN) goto handle_carriage_return;
	;  if (currGlyph == FONT_HORIZONTAL_TAB) goto handle_horizontal_tab;
	;
	;  handle_drawing_glyph:
	;    call(currGlyph, currX, currY);
	;    currX += TILE_WIDTH;
	;    goto finished_handling_glyph;
	;
	;  handle_line_feed:
	;    currY += TILE_HEIGHT;
	;    if (make_nl_as_crnl) currX = startX;
	;    goto finished_handling_glyph;
	;
	;  handle_carriage_return:
	;    currX = startX;
	;    if (make_cr_as_crnl) currY += TILE_HEIGHT;
	;    goto finished_handling_glyph;
	;
	;  handle_horizontal_tab:
	;    currX += TILE_WIDTH * get_tab_space
	;    goto finished_handling_glyph;
	;
	;  finished_handling_glyph:
	;}
	;
	; WIP
	;

	ret
