%ifndef KEYBOARD_INC
%define KEYBOARD_INC

%define PS2_DATA	0x60
%define PS2_STATUS	0x64
%define PS2_COMMAND	0x64

%define INPUT_BUFFER_FULL	(1 << 0)
%define OUTPUT_BUFFER_FULL	(1 << 1)
%define SYSTEM_FLAG			(1 << 2)
%define COMMAND_DATA_FLAG	(1 << 3)
%define UNK1				(1 << 4)
%define UNK2				(1 << 5)
%define TIMEOUT_FLAG		(1 << 6)
%define PARITY_FLAG			(1 << 7)

extern keyboardRead
extern keyboardFlushBuffer
extern scancode

%endif
