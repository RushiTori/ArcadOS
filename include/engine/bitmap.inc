%ifndef BITMAP_INC
%define BITMAP_INC

%include "engine/display.inc"

; Bitmap formal definition
struc Bitmap
    ; The bits array, each byte contains 8 bits
    ; uint8_t* bits;
    struc_member(pointer_t, bits, 1)

	; Width of the bits array
	; uint16_t width;
	struc_member(uint16_t, width, 1)

	; Height of the bits array
	; uint16_t height;
	struc_member(uint16_t, height, 1)

    .padding: resb 4 ; Padding to make the struct 16 bytes
endstruc

;
;bitmap get bit
;bitmap get bit vec
;bitmap get bit indexed
;bitmap set bit
;bitmap set bit vec
;bitmap set bit indexed
;draw bitmap
;draw bitmap vec
;draw bitmap rec
;draw bitmap rec vec
;draw bitmap masked
;draw bitmap masked vec
;draw bitmap masked rec
;draw bitmap masked rec vec
;

%endif ; BITMAP_INC
