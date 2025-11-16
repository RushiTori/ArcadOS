bits    64
default rel

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
    dq 0x00180018183C3C18 ; 0x21 '!'
    dq 0x0000000000123636 ; 0x22 '"'
    dq 0x0036367F367F3636 ; 0x23 '#'
    dq 0x000C1F301E033E0C ; 0x24 '$'
    dq 0x0063660C18336300 ; 0x25 '%'
    dq 0x006E333B6E1C361C ; 0x26 '&'
    dq 0x0000000000020606 ; 0x27 '''
    dq 0x00180C0606060C18 ; 0x28 '('
    dq 0x00060C1818180C06 ; 0x29 ')'
    dq 0x0000663CFF3C6600 ; 0x2A '*'
    dq 0x00000C0C3F0C0C00 ; 0x2B '+'
    dq 0x00060C0C00000000 ; 0x2C ','
    dq 0x000000003F000000 ; 0x2D '-'
    dq 0x000C0C0000000000 ; 0x2E '.'
    dq 0x000103060C183060 ; 0x2F '/'
    dq 0x003E676F7B73633E ; 0x30 '0'
    dq 0x003F0C0C0C0C0E0C ; 0x31 '1'
    dq 0x003F33061C30331E ; 0x32 '2'
    dq 0x001E33301C30331E ; 0x33 '3'
    dq 0x0078307F33363C38 ; 0x34 '4'
    dq 0x001E3330301F033F ; 0x35 '5'
    dq 0x001E33331F03061C ; 0x36 '6'
    dq 0x000C0C0C1830333F ; 0x37 '7'
    dq 0x001E33331E33331E ; 0x38 '8'
    dq 0x000E18303E33331E ; 0x39 '9'
    dq 0x000C0C00000C0C00 ; 0x3A ':'
    dq 0x00060C0C000C0C00 ; 0x3B ';'
    dq 0x00180C0603060C18 ; 0x3C '<'
    dq 0x00003F00003F0000 ; 0x3D '='
    dq 0x00060C1830180C06 ; 0x3E '>'
    dq 0x000C000C1830331E ; 0x3F '?'
    dq 0x001E037B7B7B633E ; 0x40 '@'
    dq 0x0033333F33331E0C ; 0x41 'A'
    dq 0x003F66663E66663F ; 0x42 'B'
    dq 0x003C66030303663C ; 0x43 'C'
    dq 0x001F36666666361F ; 0x44 'D'
    dq 0x007F46161E16467F ; 0x45 'E'
    dq 0x000F06161E16467F ; 0x46 'F'
    dq 0x007C66730303663C ; 0x47 'G'
    dq 0x003333333F333333 ; 0x48 'H'
    dq 0x001E0C0C0C0C0C1E ; 0x49 'I'
    dq 0x001E333330303078 ; 0x4A 'J'
    dq 0x006766361E366667 ; 0x4B 'K'
    dq 0x007F66460606060F ; 0x4C 'L'
    dq 0x0063636B7F7F7763 ; 0x4D 'M'
    dq 0x006363737B6F6763 ; 0x4E 'N'
    dq 0x001C36636363361C ; 0x4F 'O'
    dq 0x000F06063E66663F ; 0x50 'P'
    dq 0x00381E3B3333331E ; 0x51 'Q'
    dq 0x006766363E66663F ; 0x52 'R'
    dq 0x001E33380E07331E ; 0x53 'S'
    dq 0x001E0C0C0C0C2D3F ; 0x54 'T'
    dq 0x003F333333333333 ; 0x55 'U'
    dq 0x000C1E3333333333 ; 0x56 'V'
    dq 0x0063777F6B636363 ; 0x57 'W'
    dq 0x0063361C1C366363 ; 0x58 'X'
    dq 0x001E0C0C1E333333 ; 0x59 'Y'
    dq 0x007F664C1831637F ; 0x5A 'Z'
    dq 0x001E06060606061E ; 0x5B '['
    dq 0x00406030180C0603 ; 0x5C '\'
    dq 0x001E18181818181E ; 0x5D ']'
    dq 0x0000000063361C08 ; 0x5E '^'
    dq 0x00FF000000000000 ; 0x5F '_'
    dq 0x0000000000180C0C ; 0x60 '`'
    dq 0x006E333E301E0000 ; 0x61 'a'
    dq 0x003B66663E060607 ; 0x62 'b'
    dq 0x001E3303331E0000 ; 0x63 'c'
    dq 0x006E33333E303038 ; 0x64 'd'
    dq 0x001E033F331E0000 ; 0x65 'e'
    dq 0x000F06060F06361C ; 0x66 'f'
    dq 0x001F303E33336E00 ; 0x67 'g'
    dq 0x006766666E360607 ; 0x68 'h'
    dq 0x001E0C0C0C0E000C ; 0x69 'i'
    dq 0x001E333330300030 ; 0x6A 'j'
    dq 0x0067361E36660607 ; 0x6B 'k'
    dq 0x001E0C0C0C0C0C0E ; 0x6C 'l'
    dq 0x00636B7F7F330000 ; 0x6D 'm'
    dq 0x00333333331F0000 ; 0x6E 'n'
    dq 0x001E3333331E0000 ; 0x6F 'o'
    dq 0x000F063E663B0000 ; 0x70 'p'
    dq 0x0078303E336E0000 ; 0x71 'q'
    dq 0x000F06666E3B0000 ; 0x72 'r'
    dq 0x001F301E033E0000 ; 0x73 's'
    dq 0x00182C0C0C3E0C08 ; 0x74 't'
    dq 0x006E333333330000 ; 0x75 'u'
    dq 0x000C1E3333330000 ; 0x76 'v'
    dq 0x00367F7F6B630000 ; 0x77 'w'
    dq 0x0063361C36630000 ; 0x78 'x'
    dq 0x001F303E33330000 ; 0x79 'y'
    dq 0x003F260C193F0000 ; 0x7A 'z'
    dq 0x00380C0C070C0C38 ; 0x7B '{'
    dq 0x0018181800181818 ; 0x7C '|'
    dq 0x00070C0C380C0C07 ; 0x7D '}'
    dq 0x0000003B6E000000 ; 0x7E '~'
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
    dq 0x0000000000000000 ; 0x98 '¢'
    dq 0x0000000000000000 ; 0x99 '£'
    dq 0x0000000000000000 ; 0x9A '€'
    dq 0x0000000000000000 ; 0x9B '¥'
    dq 0x0000000000000000 ; 0x9C UNDEFINED
    dq 0x0000000000000000 ; 0x9D UNDEFINED
    dq 0x0000000000000000 ; 0x9E UNDEFINED
    dq 0x0000000000000000 ; 0x9F UNDEFINED
    dq 0x0000000000000000 ; 0xA0 '⁰'
    dq 0x0000000000000000 ; 0xA1 '¹'
    dq 0x0000000000000000 ; 0xA2 '²'
    dq 0x0000000000000000 ; 0xA3 '³'
    dq 0x0000000000000000 ; 0xA4 '⁴'
    dq 0x0000000000000000 ; 0xA5 '⁵'
    dq 0x0000000000000000 ; 0xA6 '⁶'
    dq 0x0000000000000000 ; 0xA7 '⁷'
    dq 0x0000000000000000 ; 0xA8 '⁸'
    dq 0x0000000000000000 ; 0xA9 '⁹'
    dq 0x0000000000000000 ; 0xAA '⁺'
    dq 0x0000000000000000 ; 0xAB '⁻'
    dq 0x0000000000000000 ; 0xAC '‧'
    dq 0x0000000000000000 ; 0xAD '©'
    dq 0x0000000000000000 ; 0xAE '™'
    dq 0x0000000000000000 ; 0xAF '®'
    dq 0x0000000000000000 ; 0xB0 UNDEFINED
    dq 0x0000000000000000 ; 0xB1 UNDEFINED
    dq 0x0000000000000000 ; 0xB2 UNDEFINED
    dq 0x0000000000000000 ; 0xB3 UNDEFINED
    dq 0x0000000000000000 ; 0xB4 UNDEFINED
    dq 0x0000000000000000 ; 0xB5 UNDEFINED
    dq 0x0000000000000000 ; 0xB6 UNDEFINED
    dq 0x0000000000000000 ; 0xB7 UNDEFINED
    dq 0x0000000000000000 ; 0xB8 UNDEFINED
    dq 0x0000000000000000 ; 0xB9 UNDEFINED
    dq 0x0000000000000000 ; 0xBA UNDEFINED
    dq 0x0000000000000000 ; 0xBB UNDEFINED
    dq 0x0000000000000000 ; 0xBC UNDEFINED
    dq 0x0000000000000000 ; 0xBD UNDEFINED
    dq 0x0000000000000000 ; 0xBE UNDEFINED
    dq 0x0000000000000000 ; 0xBF UNDEFINED
    dq 0x0000000000000000 ; 0xC0 UNDEFINED
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
