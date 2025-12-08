%ifndef SNAKE_INC
%define SNAKE_INC

%include "engine/display.inc"
%include "engine/font.inc"
%include "engine/PS2keyboard.inc"
%include "engine/PIT_timer.inc"
%include "engine/rtc_timer.inc"
%include "engine/colors.inc"

%include "bootloader/pic.inc"
%include "string.inc"

%define BOARD_WIDTH 40
%define BOARD_HEIGHT 25

%define SNAKE_MAX_LENGTH BOARD_WIDTH * BOARD_HEIGHT

;void start_snake(void)
extern start_snake

%endif ;SNAKE_INC