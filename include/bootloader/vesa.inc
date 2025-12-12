%ifndef VESA_INC
%define VESA_INC

struc vbe_info_structure
    .signature: resb 4              ;should hold "VBE2" before call, and should hold "VESA" if VESA support is valid
    .version: resw 1                ;VBE version, high byte indicates major version, low byte indicate minor version
    .oem: resd 1                    ;segment offset pointer to oem
    .capabilities: resd 1           ;bitfield that describes card capabilities
    .video_modes: resd 1            ;segment:offset pointer to list of supported video modes
	.video_memory: resw 1           ;amount of video memory in 64KB blocks
	.software_rev: resw 1           ;software revision
	.vendor: resd 1                 ;segment:offset to card vendor string
	.product_name: resd 1           ;segment:offset to card model name
	.product_rev: resd 1            ;segment:offset pointer to product revision
	.reserved: resb 222             ;reserved for future expansion
	.oem_data: resb 256             ;OEM BIOSes store their strings in this area
endstruc

struc vbe_mode_info_structure
	.attributes: resw 1             ;deprecated, only bit 7 should be of interest to you, and it indicates the mode supports a linear frame buffer.
	.window_a: resb 1               ;deprecated
	.window_b: resb 1               ;deprecated
	.granularity: resw 1            ;deprecated; used while calculating bank numbers
	.window_size: resw 1
	.segment_a: resw 1
	.segment_b: resw 1
	.win_func_ptr: resd 1           ;deprecated; used to switch banks from protected mode without returning to real mode
	.pitch: resw 1                  ;number of bytes per horizontal line
	.width: resw 1                  ;width in pixels
	.height: resw 1                 ;height in pixels
	.w_char: resb 1                 ;unused...
	.y_char: resb 1                 ;...
	.planes: resb 1
	.bpp: resb 1                    ;bits per pixel in this mode
	.banks: resb 1                  ;deprecated; total number of banks in this mode
	.memory_model: resb 1
	.bank_size: resb 1              ;deprecated; size of a bank, almost always 64 KB but may be 16 KB...
	.image_pages: resb 1
	.reserved0: resb 1

	.red_mask: resb 1
	.red_position: resb 1
    .green_mask: resb 1
	.green_position: resb 1
    .blue_mask: resb 1
	.blue_position: resb 1
    .reserved_mask: resb 1
	.reserved_position: resb 1
	.direct_color_attributes: resb 1

	.framebuffer: resd 1            ;physical address of the linear frame buffer; write here to draw to the screen
	.off_screen_mem_off: resd 1
	.off_screen_mem_size: resw 1    ;size of memory in the framebuffer but not being displayed on the screen
	.reserved1: resb 206
endstruc

struc vbe2_pmi_table
	.set_window: resw 1                 ;uint16_t set_window;		// offset in table for protected mode code for function 0x4F05
	.set_display_start: resw 1          ;uint16_t set_display_start;	// offset in table for protected mode code for function 0x4F07
	.set_palette: resw 1                ;uint16_t set_pallette;		// offset in table for protected mode code for function 0x4F09
endstruc


extern data_vbe_mode_info_structure
extern setup_vesa_mode

%endif