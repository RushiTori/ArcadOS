bits 64

%include "engine/font.inc"

section .rodata

font_data:
static font_data:data
    dq 0x0000000000000000 ; 0x00 (nul)
    dq 0x0000000000000000 ; 0x01
    dq 0x0000000000000000 ; 0x02
    dq 0x0000000000000000 ; 0x03
    dq 0x0000000000000000 ; 0x04
    dq 0x0000000000000000 ; 0x05
    dq 0x0000000000000000 ; 0x06
    dq 0x0000000000000000 ; 0x07
    dq 0x0000000000000000 ; 0x08
    dq 0x0000000000000000 ; 0x09
    dq 0x0000000000000000 ; 0x0A
    dq 0x0000000000000000 ; 0x0B
    dq 0x0000000000000000 ; 0x0C
    dq 0x0000000000000000 ; 0x0D
    dq 0x0000000000000000 ; 0x0E
    dq 0x0000000000000000 ; 0x0F
    dq 0x0000000000000000 ; 0x10
    dq 0x0000000000000000 ; 0x11
    dq 0x0000000000000000 ; 0x12
    dq 0x0000000000000000 ; 0x13
    dq 0x0000000000000000 ; 0x14
    dq 0x0000000000000000 ; 0x15
    dq 0x0000000000000000 ; 0x16
    dq 0x0000000000000000 ; 0x17
    dq 0x0000000000000000 ; 0x18
    dq 0x0000000000000000 ; 0x19
    dq 0x0000000000000000 ; 0x1A
    dq 0x0000000000000000 ; 0x1B
    dq 0x0000000000000000 ; 0x1C
    dq 0x0000000000000000 ; 0x1D
    dq 0x0000000000000000 ; 0x1E
    dq 0x0000000000000000 ; 0x1F
    dq 0x0000000000000000 ; 0x20 (space)
    dq 0x183C3C1818001800 ; 0x21 (!)
    dq 0x6C6C000000000000 ; 0x22 (")
    dq 0x6C6CFE6CFE6C6C00 ; 0x23 (#)
    dq 0x307CC0780CF83000 ; 0x24 ($)
    dq 0x00C6CC183066C600 ; 0x25 (%)
    dq 0x386C3876DCCC7600 ; 0x26 (&)
    dq 0x6060C00000000000 ; 0x27 (')
    dq 0x1830606060301800 ; 0x28 (()
    dq 0x6030181818306000 ; 0x29 ())
    dq 0x00663CFF3C660000 ; 0x2A (*)
    dq 0x003030FC30300000 ; 0x2B (+)
    dq 0x0000000000303060 ; 0x2C (,)
    dq 0x000000FC00000000 ; 0x2D (-)
    dq 0x0000000000303000 ; 0x2E (.)
    dq 0x060C183060C08000 ; 0x2F (/)
    dq 0x7CC6CEDEF6E67C00 ; 0x30 (0)
    dq 0x307030303030FC00 ; 0x31 (1)
    dq 0x78CC0C3860CCFC00 ; 0x32 (2)
    dq 0x78CC0C380CCC7800 ; 0x33 (3)
    dq 0x1C3C6CCCFE0C1E00 ; 0x34 (4)
    dq 0xFCC0F80C0CCC7800 ; 0x35 (5)
    dq 0x3860C0F8CCCC7800 ; 0x36 (6)
    dq 0xFCCC0C1830303000 ; 0x37 (7)
    dq 0x78CCCC78CCCC7800 ; 0x38 (8)
    dq 0x78CCCC7C0C187000 ; 0x39 (9)
    dq 0x0030300000303000 ; 0x3A (:)
    dq 0x0030300000303060 ; 0x3B (;)
    dq 0x183060C060301800 ; 0x3C (<)
    dq 0x0000FC0000FC0000 ; 0x3D (=)
    dq 0x6030180C18306000 ; 0x3E (>)
    dq 0x78CC0C1830003000 ; 0x3F (?)
    dq 0x7CC6DEDEDEC07800 ; 0x40 (@)
    dq 0x3078CCCCFCCCCC00 ; 0x41 (A)
    dq 0xFC66667C6666FC00 ; 0x42 (B)
    dq 0x3C66C0C0C0663C00 ; 0x43 (C)
    dq 0xF86C6666666CF800 ; 0x44 (D)
    dq 0xFE6268786862FE00 ; 0x45 (E)
    dq 0xFE6268786860F000 ; 0x46 (F)
    dq 0x3C66C0C0CE663E00 ; 0x47 (G)
    dq 0xCCCCCCFCCCCCCC00 ; 0x48 (H)
    dq 0x7830303030307800 ; 0x49 (I)
    dq 0x1E0C0C0CCCCC7800 ; 0x4A (J)
    dq 0xE6666C786C66E600 ; 0x4B (K)
    dq 0xF06060606266FE00 ; 0x4C (L)
    dq 0xC6EEFEFED6C6C600 ; 0x4D (M)
    dq 0xC6E6F6DECEC6C600 ; 0x4E (N)
    dq 0x386CC6C6C66C3800 ; 0x4F (O)
    dq 0xFC66667C6060F000 ; 0x50 (P)
    dq 0x78CCCCCCDC781C00 ; 0x51 (Q)
    dq 0xFC66667C6C66E600 ; 0x52 (R)
    dq 0x78CCE0701CCC7800 ; 0x53 (S)
    dq 0xFCB4303030307800 ; 0x54 (T)
    dq 0xCCCCCCCCCCCCFC00 ; 0x55 (U)
    dq 0xCCCCCCCCCC783000 ; 0x56 (V)
    dq 0xC6C6C6D6FEEEC600 ; 0x57 (W)
    dq 0xC6C66C38386CC600 ; 0x58 (X)
    dq 0xCCCCCC7830307800 ; 0x59 (Y)
    dq 0xFEC68C183266FE00 ; 0x5A (Z)
    dq 0x7860606060607800 ; 0x5B ([)
    dq 0xC06030180C060200 ; 0x5C (\)
    dq 0x7818181818187800 ; 0x5D (])
    dq 0x10386CC600000000 ; 0x5E (^)
    dq 0x00000000000000FF ; 0x5F (_)
    dq 0x3030180000000000 ; 0x60 (`)
    dq 0x0000780C7CCC7600 ; 0x61 (a)
    dq 0xE060607C6666DC00 ; 0x62 (b)
    dq 0x000078CCC0CC7800 ; 0x63 (c)
    dq 0x1C0C0C7CCCCC7600 ; 0x64 (d)
    dq 0x000078CCFCC07800 ; 0x65 (e)
    dq 0x386C60F06060F000 ; 0x66 (f)
    dq 0x000076CCCC7C0CF8 ; 0x67 (g)
    dq 0xE0606C766666E600 ; 0x68 (h)
    dq 0x3000703030307800 ; 0x69 (i)
    dq 0x0C000C0C0CCCCC78 ; 0x6A (j)
    dq 0xE060666C786CE600 ; 0x6B (k)
    dq 0x7030303030307800 ; 0x6C (l)
    dq 0x0000CCFEFED6C600 ; 0x6D (m)
    dq 0x0000F8CCCCCCCC00 ; 0x6E (n)
    dq 0x000078CCCCCC7800 ; 0x6F (o)
    dq 0x0000DC66667C60F0 ; 0x70 (p)
    dq 0x000076CCCC7C0C1E ; 0x71 (q)
    dq 0x0000DC766660F000 ; 0x72 (r)
    dq 0x00007CC0780CF800 ; 0x73 (s)
    dq 0x10307C3030341800 ; 0x74 (t)
    dq 0x0000CCCCCCCC7600 ; 0x75 (u)
    dq 0x0000CCCCCC783000 ; 0x76 (v)
    dq 0x0000C6D6FEFE6C00 ; 0x77 (w)
    dq 0x0000C66C386CC600 ; 0x78 (x)
    dq 0x0000CCCCCC7C0CF8 ; 0x79 (y)
    dq 0x0000FC983064FC00 ; 0x7A (z)
    dq 0x1C3030E030301C00 ; 0x7B ({)
    dq 0x1818180018181800 ; 0x7C (|)
    dq 0xE030301C3030E000 ; 0x7D (})
    dq 0x76DC000000000000 ; 0x7E (~)
    dq 0x0000000000000000 ; 0x7F
    dq 0x0000000000000000 ; 0x80
    dq 0x0000000000000000 ; 0x81
    dq 0x0000000000000000 ; 0x82
    dq 0x0000000000000000 ; 0x83
    dq 0x0000000000000000 ; 0x84
    dq 0x0000000000000000 ; 0x85
    dq 0x0000000000000000 ; 0x86
    dq 0x0000000000000000 ; 0x87
    dq 0x0000000000000000 ; 0x88
    dq 0x0000000000000000 ; 0x89
    dq 0x0000000000000000 ; 0x8A
    dq 0x0000000000000000 ; 0x8B
    dq 0x0000000000000000 ; 0x8C
    dq 0x0000000000000000 ; 0x8D
    dq 0x0000000000000000 ; 0x8E
    dq 0x0000000000000000 ; 0x8F
    dq 0x0000000000000000 ; 0x90
    dq 0x0000000000000000 ; 0x91
    dq 0x0000000000000000 ; 0x92
    dq 0x0000000000000000 ; 0x93
    dq 0x0000000000000000 ; 0x94
    dq 0x0000000000000000 ; 0x95
    dq 0x0000000000000000 ; 0x96
    dq 0x0000000000000000 ; 0x97
    dq 0x0000000000000000 ; 0x98
    dq 0x0000000000000000 ; 0x99
    dq 0x0000000000000000 ; 0x9A
    dq 0x0000000000000000 ; 0x9B
    dq 0x0000000000000000 ; 0x9C
    dq 0x0000000000000000 ; 0x9D
    dq 0x0000000000000000 ; 0x9E
    dq 0x0000000000000000 ; 0x9F
    dq 0x0000000000000000 ; 0xA0
    dq 0x0000000000000000 ; 0xA1
    dq 0x0000000000000000 ; 0xA2
    dq 0x0000000000000000 ; 0xA3
    dq 0x0000000000000000 ; 0xA4
    dq 0x0000000000000000 ; 0xA5
    dq 0x0000000000000000 ; 0xA6
    dq 0x0000000000000000 ; 0xA7
    dq 0x0000000000000000 ; 0xA8
    dq 0x0000000000000000 ; 0xA9
    dq 0x0000000000000000 ; 0xAA
    dq 0x0000000000000000 ; 0xAB
    dq 0x0000000000000000 ; 0xAC
    dq 0x0000000000000000 ; 0xAD
    dq 0x0000000000000000 ; 0xAE
    dq 0x0000000000000000 ; 0xAF
    dq 0x0000000000000000 ; 0xB0
    dq 0x0000000000000000 ; 0xB1
    dq 0x0000000000000000 ; 0xB2
    dq 0x0000000000000000 ; 0xB3
    dq 0x0000000000000000 ; 0xB4
    dq 0x0000000000000000 ; 0xB5
    dq 0x0000000000000000 ; 0xB6
    dq 0x0000000000000000 ; 0xB7
    dq 0x0000000000000000 ; 0xB8
    dq 0x0000000000000000 ; 0xB9
    dq 0x0000000000000000 ; 0xBA
    dq 0x0000000000000000 ; 0xBB
    dq 0x0000000000000000 ; 0xBC
    dq 0x0000000000000000 ; 0xBD
    dq 0x0000000000000000 ; 0xBE
    dq 0x0000000000000000 ; 0xBF
    dq 0x0000000000000000 ; 0xC0
    dq 0x0000000000000000 ; 0xC1
    dq 0x0000000000000000 ; 0xC2
    dq 0x0000000000000000 ; 0xC3
    dq 0x0000000000000000 ; 0xC4
    dq 0x0000000000000000 ; 0xC5
    dq 0x0000000000000000 ; 0xC6
    dq 0x0000000000000000 ; 0xC7
    dq 0x0000000000000000 ; 0xC8
    dq 0x0000000000000000 ; 0xC9
    dq 0x0000000000000000 ; 0xCA
    dq 0x0000000000000000 ; 0xCB
    dq 0x0000000000000000 ; 0xCC
    dq 0x0000000000000000 ; 0xCD
    dq 0x0000000000000000 ; 0xCE
    dq 0x0000000000000000 ; 0xCF
    dq 0x0000000000000000 ; 0xD0
    dq 0x0000000000000000 ; 0xD1
    dq 0x0000000000000000 ; 0xD2
    dq 0x0000000000000000 ; 0xD3
    dq 0x0000000000000000 ; 0xD4
    dq 0x0000000000000000 ; 0xD5
    dq 0x0000000000000000 ; 0xD6
    dq 0x0000000000000000 ; 0xD7
    dq 0x0000000000000000 ; 0xD8
    dq 0x0000000000000000 ; 0xD9
    dq 0x0000000000000000 ; 0xDA
    dq 0x0000000000000000 ; 0xDB
    dq 0x0000000000000000 ; 0xDC
    dq 0x0000000000000000 ; 0xDD
    dq 0x0000000000000000 ; 0xDE
    dq 0x0000000000000000 ; 0xDF
    dq 0x0000000000000000 ; 0xE0
    dq 0x0000000000000000 ; 0xE1
    dq 0x0000000000000000 ; 0xE2
    dq 0x0000000000000000 ; 0xE3
    dq 0x0000000000000000 ; 0xE4
    dq 0x0000000000000000 ; 0xE5
    dq 0x0000000000000000 ; 0xE6
    dq 0x0000000000000000 ; 0xE7
    dq 0x0000000000000000 ; 0xE8
    dq 0x0000000000000000 ; 0xE9
    dq 0x0000000000000000 ; 0xEA
    dq 0x0000000000000000 ; 0xEB
    dq 0x0000000000000000 ; 0xEC
    dq 0x0000000000000000 ; 0xED
    dq 0x0000000000000000 ; 0xEE
    dq 0x0000000000000000 ; 0xEF
    dq 0x0000000000000000 ; 0xF0
    dq 0x0000000000000000 ; 0xF1
    dq 0x0000000000000000 ; 0xF2
    dq 0x0000000000000000 ; 0xF3
    dq 0x0000000000000000 ; 0xF4
    dq 0x0000000000000000 ; 0xF5
    dq 0x0000000000000000 ; 0xF6
    dq 0x0000000000000000 ; 0xF7
    dq 0x0000000000000000 ; 0xF8
    dq 0x0000000000000000 ; 0xF9
    dq 0x0000000000000000 ; 0xFA
    dq 0x0000000000000000 ; 0xFB
    dq 0x0000000000000000 ; 0xFC
    dq 0x0000000000000000 ; 0xFD
    dq 0x0000000000000000 ; 0xFE
    dq 0x0000000000000000 ; 0xFF

section .data

current_glyph_color:
static current_glyph_color:data
    db 0

font_color:
static font_color:data
	db 0x1F

shadow_color:
static shadow_color:data
	db 0x1B

background_color:
static background_color:data
	db 0x13

section .text

; args : u8 color
set_font_color:
global set_font_color:function
	mov byte[font_color], dil
	ret

; args : u8 color
set_font_shadow_color:
global set_font_shadow_color:function
	mov byte[shadow_color], dil
	ret

; args : u8 color
set_font_background_color:
global set_font_background_color:function
	mov byte[background_color], dil
	ret

; args : u8 color, u8 shadow_color, u8 bg_color
set_font_colors:
global set_font_colors:function
	mov byte[font_color], dil
	mov byte[shadow_color], sil
	mov byte[background_color], dl
	ret

; if ah is set, the bitmap is inversed
; args : u16 x, u16 y, u8 glyph
draw_glyph_base:
static draw_glyph_base:function
	cmp di, SCREEN_WIDTH
	jae .end
	cmp si, SCREEN_HEIGHT
	jae .end

	mov al, byte[current_glyph_color]

	and rdx, 0xFF
	mov r11, qword[font_data + rdx * 8]
    cmp ah, false
    je .skip_inverse_bitmap
    not r11
    .skip_inverse_bitmap:
	mov rdx, 1 << 63

	mov r10, SCREEN_WIDTH
	imul r10w, si
	add r10w, di

	mov r8, SCREEN_WIDTH
	sub r8w, di
    cmp r8, 8
    jle .skip_min_x1
    mov r8, 8
    .skip_min_x1:

	mov r9, SCREEN_HEIGHT
	sub r9w, si
    cmp r9, 8
    jle .skip_min_y
    mov r9, 8
    .skip_min_y:

	.loop_y:
		.loop_x:
            mov rcx, r11
			and rcx, rdx
			jz .skip_put_pixel
			mov byte[VGA_MEMORY_ADDR + r10], al
			.skip_put_pixel:
            shr rdx, 1
			inc r10w
			dec r8
			jnz .loop_x
		.end_loop_x:

	    mov r8, SCREEN_WIDTH
	    sub r8w, di
        cmp r8, 8
        jle .skip_min_x2
        mov r8, 8
        .skip_min_x2:

        mov cl, 8
        sub cl, r8b
        shr rdx, cl

		add r10w, SCREEN_WIDTH
		sub r10w, r8w
		dec r9
		jnz .loop_y
	.end_loop_y:

	.end:
	ret

; args : u16 x, u16 y, u8 glyph
draw_glyph:
global draw_glyph:function
    mov al, byte[font_color]
    mov byte[current_glyph_color], al
    xor ah, ah
    call draw_glyph_base
    ret

; args : u16 x, u16 y, u8 glyph
draw_glyph_shadow:
global draw_glyph_shadow:function
    mov al, byte[shadow_color]
    mov byte[current_glyph_color], al
    inc di
    inc si
    xor ah, ah
    call draw_glyph_base
    dec di
    dec si
    ret

; args : u16 x, u16 y, u8 glyph
draw_glyph_background:
global draw_glyph_background:function
    mov al, byte[background_color]
    mov byte[current_glyph_color], al
    mov ah, true
    call draw_glyph_base
	ret

; args : u16 x, u16 y, u8* text, void(*draw_glyph_func)(u16, u16, u8)
draw_text_base:
static draw_text_base:function
    ; WIP
    push r12
    push r13
    push r14
    push r15

    mov r12, rdx
    mov r13, rcx
    mov r14, rdi
    mov r15, rsi

    .draw_loop:
        mov dl, byte[r12]

        cmp dl, 0
        je .end

        cmp dl, 0x09 ; '\t'
        je .handle_tab

        cmp dl, 0x0A ; '\n'
        je .handle_newline

        .handle_glyph:
            call r13
            add di, 8
            jmp .end_draw_loop

        .handle_newline:
            add si, 8
            mov rdi, r14
            jmp .end_draw_loop

        .handle_tab:
            mov dl, ' '
            call r13
            add di, 8
            mov dl, ' '
            call r13
            add di, 8
            mov dl, ' '
            call r13
            add di, 8
            mov dl, ' '
            call r13
            add di, 8

        .end_draw_loop:
            inc r12
            jmp .draw_loop

    .end:
    mov rdi, r14
    mov rsi, r15

    pop r15
    pop r14
    pop r13
    pop r12
    ret

; args : u16 x, u16 y, u8* text
draw_text:
global draw_text:function
    mov rcx, draw_glyph
    call draw_text_base
	ret

; args : u16 x, u16 y, u8* text
draw_text_shadow:
global draw_text_shadow:function
    mov rcx, draw_glyph_shadow
    call draw_text_base
	ret

; args : u16 x, u16 y, u8* text
draw_text_background:
global draw_text_background:function
    mov rcx, draw_glyph_background
    call draw_text_base
	ret
