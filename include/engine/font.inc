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

%define FONT_WIDTH              16
%define FONT_HEIGHT             16

%define FONT_LINE_FEED          0x0A
%define FONT_NEW_LINE           FONT_LINE_FEED

%define FONT_CARRIAGE_RETURN    0x0D

%define FONT_HORIZONTAL_TAB     0x09
%define FONT_TAB                FONT_HORIZONTAL_TAB

%define DEFAULT_TAB_SPACES      2
%define DEFAULT_MAKE_NL_AS_CRNL true
%define DEFAULT_MAKE_CR_AS_CRNL false

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

; const TiledBitmap* get_default_font(void);
extern get_default_font

; const TiledBitmap* get_current_font(void);
extern get_current_font

; void set_current_font(const TiledBitmap* font);
extern set_current_font

; uint8_t get_tab_space(void);
extern get_tab_space

; void set_tab_space(uint8_t spaces);
extern set_tab_space

; bool_t get_make_nl_as_crnl(void);
extern get_make_nl_as_crnl

; void set_make_nl_as_crnl(void);
extern set_make_nl_as_crnl

; void unset_make_nl_as_crnl(void);
extern unset_make_nl_as_crnl

; bool_t get_make_cr_as_crnl(void);
extern get_make_cr_as_crnl

; void set_make_cr_as_crnl(void);
extern set_make_cr_as_crnl

; void unset_make_cr_as_crnl(void);
extern unset_make_cr_as_crnl

; uint8_t get_font_color(void);
extern get_font_color

; void set_font_color(uint8_t col);
extern set_font_color

; uint8_t get_font_background_color(void);
extern get_font_background_color

; void set_font_background_color(uint8_t col);
extern set_font_background_color

; uint8_t get_font_shadow_color(void);
extern get_font_shadow_color

; void set_font_shadow_color(uint8_t col);
extern set_font_shadow_color

; void set_all_font_colors(uint8_t fontCol, uint8_t backCol, uint8_t shadowCol);
extern set_all_font_colors

; void draw_glyph(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph

; void draw_glyph_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_vec

; void draw_glyph_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
extern draw_glyph_c

; void draw_glyph_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
extern draw_glyph_c_vec

; void draw_glyph_background(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_background

; void draw_glyph_background_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_background_vec

; void draw_glyph_background_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
extern draw_glyph_background_c

; void draw_glyph_background_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
extern draw_glyph_background_c_vec

; void draw_glyph_shadow(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_shadow

; void draw_glyph_shadow_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_shadow_vec

; void draw_glyph_shadow_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t col);
extern draw_glyph_shadow_c

; void draw_glyph_shadow_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t col);
extern draw_glyph_shadow_c_vec

; void draw_glyph_and_background(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_and_background

; void draw_glyph_and_background_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_and_background_vec

; void draw_glyph_and_background_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t backCol);
extern draw_glyph_and_background_c

; void draw_glyph_and_background_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t fontCol, uint8_t backCol);
extern draw_glyph_and_background_c_vec

; void draw_glyph_and_shadow(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_and_shadow

; void draw_glyph_and_shadow_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_and_shadow_vec

; void draw_glyph_and_shadow_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t shadowCol);
extern draw_glyph_and_shadow_c

; void draw_glyph_and_shadow_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t fontCol, uint8_t shadowCol);
extern draw_glyph_and_shadow_c_vec

; void draw_glyph_background_and_shadow(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_background_and_shadow

; void draw_glyph_background_and_shadow_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_background_and_shadow_vec

; void draw_glyph_background_and_shadow_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t backCol, uint8_t shadowCol);
extern draw_glyph_background_and_shadow_c

; void draw_glyph_background_and_shadow_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t backCol, uint8_t shadowCol);
extern draw_glyph_background_and_shadow_c_vec

; void draw_glyph_all(uint8_t glyph, uint16_t x, uint16_t y);
extern draw_glyph_all

; void draw_glyph_all_vec(uint8_t glyph, ScreenVec2 pos);
extern draw_glyph_all_vec

; void draw_glyph_all_c(uint8_t glyph, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t backCol, uint8_t shadowCol);
extern draw_glyph_all_c

; void draw_glyph_all_c_vec(uint8_t glyph, ScreenVec2 pos, uint8_t fontCol, uint8_t backCol, uint8_t shadowCol);
extern draw_glyph_all_c_vec

; void draw_text(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text

; void draw_text_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_vec

; void draw_text_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
extern draw_text_c

; void draw_text_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
extern draw_text_c_vec

; void draw_text_background(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_background

; void draw_text_background_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_background_vec

; void draw_text_background_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
extern draw_text_background_c

; void draw_text_background_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
extern draw_text_background_c_vec

; void draw_text_shadow(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_shadow

; void draw_text_shadow_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_shadow_vec

; void draw_text_shadow_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t col);
extern draw_text_shadow_c

; void draw_text_shadow_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t col);
extern draw_text_shadow_c_vec

; void draw_text_and_background(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_and_background

; void draw_text_and_background_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_and_background_vec

; void draw_text_and_background_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t backCol);
extern draw_text_and_background_c

; void draw_text_and_background_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t fontCol, uint8_t backCol);
extern draw_text_and_background_c_vec

; void draw_text_and_shadow(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_and_shadow

; void draw_text_and_shadow_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_and_shadow_vec

; void draw_text_and_shadow_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t shadowCol);
extern draw_text_and_shadow_c

; void draw_text_and_shadow_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t fontCol, uint8_t shadowCol);
extern draw_text_and_shadow_c_vec

; void draw_text_background_and_shadow(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_background_and_shadow

; void draw_text_background_and_shadow_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_background_and_shadow_vec

; void draw_text_background_and_shadow_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t backCol, uint8_t shadowCol);
extern draw_text_background_and_shadow_c

; void draw_text_background_and_shadow_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t backCol, uint8_t shadowCol);
extern draw_text_background_and_shadow_c_vec

; void draw_text_all(const uint8_t* glyphs, uint16_t x, uint16_t y);
extern draw_text_all

; void draw_text_all_vec(const uint8_t* glyphs, ScreenVec2 pos);
extern draw_text_all_vec

; void draw_text_all_c(const uint8_t* glyphs, uint16_t x, uint16_t y, uint8_t fontCol, uint8_t backCol, uint8_t shadowCol);
extern draw_text_all_c

; void draw_text_all_c_vec(const uint8_t* glyphs, ScreenVec2 pos, uint8_t fontCol, uint8_t backCol, uint8_t shadowCol);
extern draw_text_all_c_vec

%endif ; FONT_INC
