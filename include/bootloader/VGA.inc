%ifndef VGA_INC
%define VGA_INC

;rdi: u8 color
;rsi: struc vbe_palette_entry rgb
extern stdvga_dac_write

extern set_graphics_mode
extern get_graphics_mode

%endif ;VGA_INC