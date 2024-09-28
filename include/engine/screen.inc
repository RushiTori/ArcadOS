%ifndef SCREEN_INC
%define SCREEN_INC

%include "standard.inc"

%define SCREEN_WIDTH    320
%define SCREEN_HEIGHT   200
%define VGA_MEMORY_ADDR 0xA0000
%define VGA_MEMORY_SIZE (SCREEN_WIDTH * SCREEN_HEIGHT)

%endif ; SCREEN_INC