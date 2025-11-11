%ifndef SCREEN_INC
%define SCREEN_INC

%include "engine/vectors.inc"

%define SCREEN_WIDTH       320
%define SCREEN_HEIGHT      200
%define VGA_MEMORY_ADDR    0xA0000                            ; 0x4000000 
%define VGA_MEMORY_SIZE    (SCREEN_WIDTH * SCREEN_HEIGHT)

%define SCREEN_TILE_SIZE   8
%define SCREEN_TILE_WIDTH  (SCREEN_WIDTH / SCREEN_TILE_SIZE)
%define SCREEN_TILE_HEIGHT (SCREEN_HEIGHT / SCREEN_TILE_SIZE)

%endif ; SCREEN_INC
