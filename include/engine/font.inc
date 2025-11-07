%ifndef FONT_INC
%define FONT_INC

%include "engine/tiled_bitmap.inc"

;
; Fonts are a special kind of TiledBitmap
;
; Fonts are tiled_bitmap where .width and .height are both always equal to 16
;
; Glyphs are indexed with their Extended ASCII values, basically means 256 different glyphs possible
;
; All glyphs will be drawable at the exception of 3 glyphs:
;    Glyph 0x0A: "line feed" or "new line", will make the text jump to next line,
;                 and if make_nl_as_crnl is set, jump back to startX
;                 default: set
;
;    Glyph 0x0D: "carriage return", will make the text jump back to startX
;                 and if make_cr_as_crnl is set, jump to next line
;                 default: unset
;
;    Glyph 0x09: "horizontal tab", will make the text jump N space to the right,
;                 you can get/set N with get/set_tab_space
;                 default: 2
;

;
;get default font
;
;get current font
;set current font
;
;get tab space
;set tab space
;
;get make nl as crnl
;set make nl as crnl
;unset make nl as crnl
;
;get make cr as crnl
;set make cr as crnl
;unset make cr as crnl
;
;get font color
;set font color
;
;get font background color
;set font background color
;
;get font shadow color
;set font shadow color
;
;set all font colors
;
;draw glyph
;draw glyph vec
;draw glyph c
;draw glyph c vec
;
;draw glyph background
;draw glyph background vec
;draw glyph background c
;draw glyph background c vec
;
;draw glyph shadow
;draw glyph shadow vec
;draw glyph shadow c
;draw glyph shadow c vec
;
;draw glyph and background
;draw glyph and background vec
;draw glyph and background c
;draw glyph and background c vec
;
;draw glyph and shadow
;draw glyph and shadow vec
;draw glyph and shadow c
;draw glyph and shadow c vec
;
;draw glyph background and shadow
;draw glyph background and shadow vec
;draw glyph background and shadow c
;draw glyph background and shadow c vec
;
;draw glyph all
;draw glyph all vec
;draw glyph all c
;draw glyph all c vec
;
;draw text
;draw text vec
;draw text c
;draw text c vec
;
;draw text background
;draw text background vec
;draw text background c
;draw text background c vec
;
;draw text shadow
;draw text shadow vec
;draw text shadow c
;draw text shadow c vec
;
;draw text and background
;draw text and background vec
;draw text and background c
;draw text and background c vec
;
;draw text and shadow
;draw text and shadow vec
;draw text and shadow c
;draw text and shadow c vec
;
;draw text background and shadow
;draw text background and shadow vec
;draw text background and shadow c
;draw text background and shadow c vec
;
;draw text all
;draw text all vec
;draw text all c
;draw text all c vec
;

%endif ; FONT_INC
