%ifndef SCREEN_INC
%define SCREEN_INC

%include "standard.inc"
%include "engine/colors.inc"

%define SCREEN_WIDTH    320
%define SCREEN_HEIGHT   200
%define VGA_MEMORY_ADDR 0xA0000	;0x4000000
%define VGA_MEMORY_SIZE (SCREEN_WIDTH * SCREEN_HEIGHT)

%endif ; SCREEN_INC
