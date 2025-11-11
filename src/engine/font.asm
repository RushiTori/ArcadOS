bits    64

%include "engine/font.inc"

section .rodata

default_font_glyphs:
static  default_font_glyphs:data
    dq 0x0000000000000000 ; 0x00 not-printable NUL
    dq 0x0000000000000000 ; 0x01 UNDEFINED
    dq 0x0000000000000000 ; 0x02 UNDEFINED
    dq 0x0000000000000000 ; 0x03 UNDEFINED
    dq 0x0000000000000000 ; 0x04 UNDEFINED
    dq 0x0000000000000000 ; 0x05 UNDEFINED
    dq 0x0000000000000000 ; 0x06 UNDEFINED
    dq 0x0000000000000000 ; 0x07 UNDEFINED
    dq 0x0000000000000000 ; 0x08 UNDEFINED
    dq 0x0000000000000000 ; 0x09 not-printable HORIZONTAL_TAB
    dq 0x0000000000000000 ; 0x0A not-printable LINE_FEED
    dq 0x0000000000000000 ; 0x0B UNDEFINED
    dq 0x0000000000000000 ; 0x0C UNDEFINED
    dq 0x0000000000000000 ; 0x0D not-printable CARRIAGE_RETURN
    dq 0x0000000000000000 ; 0x0E UNDEFINED
    dq 0x0000000000000000 ; 0x0F UNDEFINED
    dq 0x0000000000000000 ; 0x10 UNDEFINED
    dq 0x0000000000000000 ; 0x11 UNDEFINED
    dq 0x0000000000000000 ; 0x12 UNDEFINED
    dq 0x0000000000000000 ; 0x13 UNDEFINED
    dq 0x0000000000000000 ; 0x14 UNDEFINED
    dq 0x0000000000000000 ; 0x15 UNDEFINED
    dq 0x0000000000000000 ; 0x16 UNDEFINED
    dq 0x0000000000000000 ; 0x17 UNDEFINED
    dq 0x0000000000000000 ; 0x18 UNDEFINED
    dq 0x0000000000000000 ; 0x19 UNDEFINED
    dq 0x0000000000000000 ; 0x1A UNDEFINED
    dq 0x0000000000000000 ; 0x1B UNDEFINED
    dq 0x0000000000000000 ; 0x1C UNDEFINED
    dq 0x0000000000000000 ; 0x1D UNDEFINED
    dq 0x0000000000000000 ; 0x1E UNDEFINED
    dq 0x0000000000000000 ; 0x1F UNDEFINED
    dq 0x0000000000000000 ; 0x20 ' '
    dq 0x183C3C1818001800 ; 0x21 '!'
    dq 0x6C6C000000000000 ; 0x22 '"'
    dq 0x6C6CFE6CFE6C6C00 ; 0x23 '#'
    dq 0x307CC0780CF83000 ; 0x24 '$'
    dq 0x00C6CC183066C600 ; 0x25 '%'
    dq 0x386C3876DCCC7600 ; 0x26 '&'
    dq 0x6060C00000000000 ; 0x27 '''
    dq 0x1830606060301800 ; 0x28 '('
    dq 0x6030181818306000 ; 0x29 ')'
    dq 0x00663CFF3C660000 ; 0x2A '*'
    dq 0x003030FC30300000 ; 0x2B '+'
    dq 0x0000000000303060 ; 0x2C ','
    dq 0x000000FC00000000 ; 0x2D '-'
    dq 0x0000000000303000 ; 0x2E '.'
    dq 0x060C183060C08000 ; 0x2F '/'
    dq 0x7CC6CEDEF6E67C00 ; 0x30 '0'
    dq 0x307030303030FC00 ; 0x31 '1'
    dq 0x78CC0C3860CCFC00 ; 0x32 '2'
    dq 0x78CC0C380CCC7800 ; 0x33 '3'
    dq 0x1C3C6CCCFE0C1E00 ; 0x34 '4'
    dq 0xFCC0F80C0CCC7800 ; 0x35 '5'
    dq 0x3860C0F8CCCC7800 ; 0x36 '6'
    dq 0xFCCC0C1830303000 ; 0x37 '7'
    dq 0x78CCCC78CCCC7800 ; 0x38 '8'
    dq 0x78CCCC7C0C187000 ; 0x39 '9'
    dq 0x0030300000303000 ; 0x3A ':'
    dq 0x0030300000303060 ; 0x3B ';'
    dq 0x183060C060301800 ; 0x3C '<'
    dq 0x0000FC0000FC0000 ; 0x3D '='
    dq 0x6030180C18306000 ; 0x3E '>'
    dq 0x78CC0C1830003000 ; 0x3F '?'
    dq 0x7CC6DEDEDEC07800 ; 0x40 '@'
    dq 0x3078CCCCFCCCCC00 ; 0x41 'A'
    dq 0xFC66667C6666FC00 ; 0x42 'B'
    dq 0x3C66C0C0C0663C00 ; 0x43 'C'
    dq 0xF86C6666666CF800 ; 0x44 'D'
    dq 0xFE6268786862FE00 ; 0x45 'E'
    dq 0xFE6268786860F000 ; 0x46 'F'
    dq 0x3C66C0C0CE663E00 ; 0x47 'G'
    dq 0xCCCCCCFCCCCCCC00 ; 0x48 'H'
    dq 0x7830303030307800 ; 0x49 'I'
    dq 0x1E0C0C0CCCCC7800 ; 0x4A 'J'
    dq 0xE6666C786C66E600 ; 0x4B 'K'
    dq 0xF06060606266FE00 ; 0x4C 'L'
    dq 0xC6EEFEFED6C6C600 ; 0x4D 'M'
    dq 0xC6E6F6DECEC6C600 ; 0x4E 'N'
    dq 0x386CC6C6C66C3800 ; 0x4F 'O'
    dq 0xFC66667C6060F000 ; 0x50 'P'
    dq 0x78CCCCCCDC781C00 ; 0x51 'Q'
    dq 0xFC66667C6C66E600 ; 0x52 'R'
    dq 0x78CCE0701CCC7800 ; 0x53 'S'
    dq 0xFCB4303030307800 ; 0x54 'T'
    dq 0xCCCCCCCCCCCCFC00 ; 0x55 'U'
    dq 0xCCCCCCCCCC783000 ; 0x56 'V'
    dq 0xC6C6C6D6FEEEC600 ; 0x57 'W'
    dq 0xC6C66C38386CC600 ; 0x58 'X'
    dq 0xCCCCCC7830307800 ; 0x59 'Y'
    dq 0xFEC68C183266FE00 ; 0x5A 'Z'
    dq 0x7860606060607800 ; 0x5B '['
    dq 0xC06030180C060200 ; 0x5C '\'
    dq 0x7818181818187800 ; 0x5D ']'
    dq 0x10386CC600000000 ; 0x5E '^'
    dq 0x00000000000000FF ; 0x5F '_'
    dq 0x3030180000000000 ; 0x60 '`'
    dq 0x0000780C7CCC7600 ; 0x61 'a'
    dq 0xE060607C6666DC00 ; 0x62 'b'
    dq 0x000078CCC0CC7800 ; 0x63 'c'
    dq 0x1C0C0C7CCCCC7600 ; 0x64 'd'
    dq 0x000078CCFCC07800 ; 0x65 'e'
    dq 0x386C60F06060F000 ; 0x66 'f'
    dq 0x000076CCCC7C0CF8 ; 0x67 'g'
    dq 0xE0606C766666E600 ; 0x68 'h'
    dq 0x3000703030307800 ; 0x69 'i'
    dq 0x0C000C0C0CCCCC78 ; 0x6A 'j'
    dq 0xE060666C786CE600 ; 0x6B 'k'
    dq 0x7030303030307800 ; 0x6C 'l'
    dq 0x0000CCFEFED6C600 ; 0x6D 'm'
    dq 0x0000F8CCCCCCCC00 ; 0x6E 'n'
    dq 0x000078CCCCCC7800 ; 0x6F 'o'
    dq 0x0000DC66667C60F0 ; 0x70 'p'
    dq 0x000076CCCC7C0C1E ; 0x71 'q'
    dq 0x0000DC766660F000 ; 0x72 'r'
    dq 0x00007CC0780CF800 ; 0x73 's'
    dq 0x10307C3030341800 ; 0x74 't'
    dq 0x0000CCCCCCCC7600 ; 0x75 'u'
    dq 0x0000CCCCCC783000 ; 0x76 'v'
    dq 0x0000C6D6FEFE6C00 ; 0x77 'w'
    dq 0x0000C66C386CC600 ; 0x78 'x'
    dq 0x0000CCCCCC7C0CF8 ; 0x79 'y'
    dq 0x0000FC983064FC00 ; 0x7A 'z'
    dq 0x1C3030E030301C00 ; 0x7B '{'
    dq 0x1818180018181800 ; 0x7C '|'
    dq 0xE030301C3030E000 ; 0x7D '}'
    dq 0x76DC000000000000 ; 0x7E '~'
    dq 0x0000000000000000 ; 0x7F '¤'
    dq 0x0000000000000000 ; 0x80 'á'
    dq 0x0000000000000000 ; 0x81 'à'
    dq 0x0000000000000000 ; 0x82 'â'
    dq 0x0000000000000000 ; 0x83 'ä'
    dq 0x0000000000000000 ; 0x84 'é'
    dq 0x0000000000000000 ; 0x85 'è'
    dq 0x0000000000000000 ; 0x86 'ê'
    dq 0x0000000000000000 ; 0x87 'ë'
    dq 0x0000000000000000 ; 0x88 'í'
    dq 0x0000000000000000 ; 0x89 'ì'
    dq 0x0000000000000000 ; 0x8A 'î'
    dq 0x0000000000000000 ; 0x8B 'ï'
    dq 0x0000000000000000 ; 0x8C 'ó'
    dq 0x0000000000000000 ; 0x8D 'ò'
    dq 0x0000000000000000 ; 0x8E 'ô'
    dq 0x0000000000000000 ; 0x8F 'ö'
    dq 0x0000000000000000 ; 0x90 'ú'
    dq 0x0000000000000000 ; 0x91 'ù'
    dq 0x0000000000000000 ; 0x92 'û'
    dq 0x0000000000000000 ; 0x93 'ü'
    dq 0x0000000000000000 ; 0x94 'ý'
    dq 0x0000000000000000 ; 0x95 'ỳ'
    dq 0x0000000000000000 ; 0x96 'ŷ'
    dq 0x0000000000000000 ; 0x97 'ÿ'
    dq 0x0000000000000000 ; 0x98 'Á'
    dq 0x0000000000000000 ; 0x99 'À'
    dq 0x0000000000000000 ; 0x9A 'Â'
    dq 0x0000000000000000 ; 0x9B 'Ä'
    dq 0x0000000000000000 ; 0x9C 'É'
    dq 0x0000000000000000 ; 0x9D 'È'
    dq 0x0000000000000000 ; 0x9E 'Ê'
    dq 0x0000000000000000 ; 0x9F 'Ë'
    dq 0x0000000000000000 ; 0xA0 'Í'
    dq 0x0000000000000000 ; 0xA1 'Ì'
    dq 0x0000000000000000 ; 0xA2 'Î'
    dq 0x0000000000000000 ; 0xA3 'Ï'
    dq 0x0000000000000000 ; 0xA4 'Ó'
    dq 0x0000000000000000 ; 0xA5 'Ò'
    dq 0x0000000000000000 ; 0xA6 'Ô'
    dq 0x0000000000000000 ; 0xA7 'Ö'
    dq 0x0000000000000000 ; 0xA8 'Ú'
    dq 0x0000000000000000 ; 0xA9 'Ù'
    dq 0x0000000000000000 ; 0xAA 'Û'
    dq 0x0000000000000000 ; 0xAB 'Ü'
    dq 0x0000000000000000 ; 0xAC 'Ý'
    dq 0x0000000000000000 ; 0xAD 'Ỳ'
    dq 0x0000000000000000 ; 0xAE 'Ŷ'
    dq 0x0000000000000000 ; 0xAF 'Ÿ'
    dq 0x0000000000000000 ; 0xB0 '£'
    dq 0x0000000000000000 ; 0xB1 '€'
    dq 0x0000000000000000 ; 0xB2 '¥'
    dq 0x0000000000000000 ; 0xB3 '¢'
    dq 0x0000000000000000 ; 0xB4 '⁰'
    dq 0x0000000000000000 ; 0xB5 '¹'
    dq 0x0000000000000000 ; 0xB6 '²'
    dq 0x0000000000000000 ; 0xB7 '³'
    dq 0x0000000000000000 ; 0xB8 '⁴'
    dq 0x0000000000000000 ; 0xB9 '⁵'
    dq 0x0000000000000000 ; 0xBA '⁶'
    dq 0x0000000000000000 ; 0xBB '⁷'
    dq 0x0000000000000000 ; 0xBC '⁸'
    dq 0x0000000000000000 ; 0xBD '⁹'
    dq 0x0000000000000000 ; 0xBE '©'
    dq 0x0000000000000000 ; 0xBF '™'
    dq 0x0000000000000000 ; 0xC0 '®'
    dq 0x0000000000000000 ; 0xC1 UNDEFINED
    dq 0x0000000000000000 ; 0xC2 UNDEFINED
    dq 0x0000000000000000 ; 0xC3 UNDEFINED
    dq 0x0000000000000000 ; 0xC4 UNDEFINED
    dq 0x0000000000000000 ; 0xC5 UNDEFINED
    dq 0x0000000000000000 ; 0xC6 UNDEFINED
    dq 0x0000000000000000 ; 0xC7 UNDEFINED
    dq 0x0000000000000000 ; 0xC8 UNDEFINED
    dq 0x0000000000000000 ; 0xC9 UNDEFINED
    dq 0x0000000000000000 ; 0xCA UNDEFINED
    dq 0x0000000000000000 ; 0xCB UNDEFINED
    dq 0x0000000000000000 ; 0xCC UNDEFINED
    dq 0x0000000000000000 ; 0xCD UNDEFINED
    dq 0x0000000000000000 ; 0xCE UNDEFINED
    dq 0x0000000000000000 ; 0xCF UNDEFINED
    dq 0x0000000000000000 ; 0xD0 UNDEFINED
    dq 0x0000000000000000 ; 0xD1 UNDEFINED
    dq 0x0000000000000000 ; 0xD2 UNDEFINED
    dq 0x0000000000000000 ; 0xD3 UNDEFINED
    dq 0x0000000000000000 ; 0xD4 UNDEFINED
    dq 0x0000000000000000 ; 0xD5 UNDEFINED
    dq 0x0000000000000000 ; 0xD6 UNDEFINED
    dq 0x0000000000000000 ; 0xD7 UNDEFINED
    dq 0x0000000000000000 ; 0xD8 UNDEFINED
    dq 0x0000000000000000 ; 0xD9 UNDEFINED
    dq 0x0000000000000000 ; 0xDA UNDEFINED
    dq 0x0000000000000000 ; 0xDB UNDEFINED
    dq 0x0000000000000000 ; 0xDC UNDEFINED
    dq 0x0000000000000000 ; 0xDD UNDEFINED
    dq 0x0000000000000000 ; 0xDE UNDEFINED
    dq 0x0000000000000000 ; 0xDF UNDEFINED
    dq 0x0000000000000000 ; 0xE0 UNDEFINED
    dq 0x0000000000000000 ; 0xE1 UNDEFINED
    dq 0x0000000000000000 ; 0xE2 UNDEFINED
    dq 0x0000000000000000 ; 0xE3 UNDEFINED
    dq 0x0000000000000000 ; 0xE4 UNDEFINED
    dq 0x0000000000000000 ; 0xE5 UNDEFINED
    dq 0x0000000000000000 ; 0xE6 UNDEFINED
    dq 0x0000000000000000 ; 0xE7 UNDEFINED
    dq 0x0000000000000000 ; 0xE8 UNDEFINED
    dq 0x0000000000000000 ; 0xE9 UNDEFINED
    dq 0x0000000000000000 ; 0xEA UNDEFINED
    dq 0x0000000000000000 ; 0xEB UNDEFINED
    dq 0x0000000000000000 ; 0xEC UNDEFINED
    dq 0x0000000000000000 ; 0xED UNDEFINED
    dq 0x0000000000000000 ; 0xEE UNDEFINED
    dq 0x0000000000000000 ; 0xEF UNDEFINED
    dq 0x0000000000000000 ; 0xF0 UNDEFINED
    dq 0x0000000000000000 ; 0xF1 UNDEFINED
    dq 0x0000000000000000 ; 0xF2 UNDEFINED
    dq 0x0000000000000000 ; 0xF3 UNDEFINED
    dq 0x0000000000000000 ; 0xF4 UNDEFINED
    dq 0x0000000000000000 ; 0xF5 UNDEFINED
    dq 0x0000000000000000 ; 0xF6 UNDEFINED
    dq 0x0000000000000000 ; 0xF7 UNDEFINED
    dq 0x0000000000000000 ; 0xF8 UNDEFINED
    dq 0x0000000000000000 ; 0xF9 UNDEFINED
    dq 0x0000000000000000 ; 0xFA UNDEFINED
    dq 0x0000000000000000 ; 0xFB UNDEFINED
    dq 0x0000000000000000 ; 0xFC UNDEFINED
    dq 0x0000000000000000 ; 0xFD UNDEFINED
    dq 0x0000000000000000 ; 0xFE UNDEFINED
    dq 0x0000000000000000 ; 0xFF UNDEFINED

default_font:
static default_font: data
	istruc TiledBitmap
        at TiledBitmap.tiles,         .tiles:  dq default_font_glyphs
        at TiledBitmap.width,         .width:  dw FONT_WIDTH
        at TiledBitmap.height,        .height: dw FONT_HEIGHT
        at TiledBitmap.main_color,    .main_color: db 0x0F
        at TiledBitmap.inverse_color, .inverse_color: db 0x00
        at TiledBitmap.padding,       .padding: dw 0
	iend

section      .data

var(static, pointer_t, current_font, default_font)
var(static, uint8_t, font_color, 0x1F)
var(static, uint8_t, shadow_color, 0x1B)
var(static, uint8_t, background_color, 0x13)
var(static, uint8_t, tab_spaces, DEFAULT_TAB_SPACES)
var(static, bool_t, make_nl_as_crnl, DEFAULT_MAKE_NL_AS_CRNL)
var(static, bool_t, make_cr_as_crnl, DEFAULT_MAKE_CR_AS_CRNL)

section      .bss

res(static,  uint8_t, current_color)

section      .text

; const TiledBitmap* get_default_font(void);
func(global, get_default_font)
    lea rax, [default_font]
    ret                     ; return &default_font

; const TiledBitmap* get_current_font(void);
func(global, get_current_font)
    mov rax, pointer_p [current_font]
    ret                               ; return &current_font

; void set_current_font(const TiledBitmap* font);
func(global, set_current_font)
    mov ax, uint16_p [rdi + TiledBitmap.width]
    cmp ax, FONT_WIDTH
    jne .end                                   ; if (font->width != FONT_WIDTH) return
    
    mov ax, uint16_p [rdi + TiledBitmap.height]
    cmp ax, FONT_HEIGHT
    jne .end                                    ; if (font->height != FONT_HEIGHT) return

    mov pointer_p [current_font], rdi ; current_font = font
    .end:
    ret

; uint8_t get_tab_space(void);
func(global, get_tab_space)
    mov al, uint8_p [tab_spaces]
    ret                          ; return tab_spaces

; void set_tab_space(uint8_t spaces);
func(global, set_tab_space)
    mov uint8_p [tab_spaces], dil ; tab_spaces = spaces
    ret

; bool_t get_make_nl_as_crnl(void);
func(global, get_make_nl_as_crnl)
    mov al, bool_p [make_nl_as_crnl]
    ret                              ; return make_nl_as_crnl

; void set_make_nl_as_crnl(void);
func(global, set_make_nl_as_crnl)
    mov bool_p [make_nl_as_crnl], true ; make_nl_as_crnl = true;
    ret

; void unset_make_nl_as_crnl(void);
func(global, unset_make_nl_as_crnl)
    mov bool_p [make_nl_as_crnl], false ; make_nl_as_crnl = false;
    ret

; bool_t get_make_cr_as_crnl(void);
func(global, get_make_cr_as_crnl)
    mov al, bool_p [make_cr_as_crnl]
    ret                              ; return make_cr_as_crnl

; void set_make_cr_as_crnl(void);
func(global, set_make_cr_as_crnl)
    mov bool_p [make_cr_as_crnl], true ; make_cr_as_crnl = true;
    ret

; void unset_make_cr_as_crnl(void);
func(global, unset_make_cr_as_crnl)
    mov bool_p [make_cr_as_crnl], false ; make_cr_as_crnl = false;
    ret

; uint8_t get_font_color(void);
func(global, get_font_color)
    mov al, uint8_p [font_color]
    ret                          ; return font_color

; void set_font_color(uint8_t col);
func(global, set_font_color)
    mov uint8_p [font_color], dil ; font_color = col
    ret

; uint8_t get_font_shadow_color(void);
func(global, get_font_shadow_color)
    mov al, uint8_p [background_color]
    ret                                ; return background_color

; void set_font_shadow_color(uint8_t col);
func(global, set_font_shadow_color)
    mov uint8_p [background_color], dil ; background_color = col
    ret

; uint8_t get_font_background_color(void);
func(global, get_font_background_color)
    mov al, uint8_p [shadow_color]
    ret                            ; return shadow_color

; void set_font_background_color(uint8_t col);
func(global, set_font_background_color)
    mov uint8_p [shadow_color], dil ; shadow_color = col
    ret

; void set_all_font_colors(uint8_t fontCol, uint8_t shadowCol, uint8_t backCol);
func(global, set_all_font_colors)
    mov uint8_p [font_color],       dil ; font_color = fontCol
    mov uint8_p [shadow_color],     sil ; shadow_color = shadowCol
    mov uint8_p [background_color], dl  ; background_color = backCol
    ret
