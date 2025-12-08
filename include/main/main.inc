%ifndef MAIN_INC
%define MAIN_INC

%include "engine/display.inc"
%include "engine/font.inc"
%include "engine/PS2keyboard.inc"
%include "engine/PIT_timer.inc"
%include "engine/rtc_timer.inc"

%include "bootloader/pic.inc"

%include "main/snake.inc"

extern main

%endif ; MAIN_INC
