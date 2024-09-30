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

extern initPS2
extern keyboardRead
extern keyboardFlushBuffer
extern keyboardSetScancodeTable
extern scancode

%define KEY_ESCAPE			0
%define KEY_F1				1
%define KEY_F2				2
%define KEY_F3				3
%define KEY_F4				4
%define KEY_F5				5
%define KEY_F6				6
%define KEY_F7				7
%define KEY_F8				8
%define KEY_F9				9
%define KEY_F10				10
%define KEY_F11				11
%define KEY_F12				12
%define KEY_INSERT			13
%define KEY_DELETE			14

%define KEY_SQUARE			16
%define KEY_ONE				17
%define KEY_TWO				18
%define KEY_THREE			19
%define KEY_FOUR			20
%define KEY_FIVE			21
%define KEY_SIX				22
%define KEY_SEVEN			23
%define KEY_EIGHT			24
%define KEY_NINE			25
%define KEY_ZERO			26
%define KEY_END_PARENTHESIS	27
%define KEY_EQUAL			28
%define KEY_BACKSPACE		29

%define KEY_TAB				32
%define KEY_A				33
%define KEY_Z				34
%define KEY_E				35
%define KEY_R				36
%define KEY_T				37
%define KEY_Y				38
%define KEY_U				39
%define KEY_I				40
%define KEY_O				41
%define KEY_P				42
%define KEY_CARET			43
%define KEY_DOLLAR			44
%define KEY_ENTER			45

%define KEY_CAPS_LOCK		48
%define KEY_Q				49
%define KEY_S				50
%define KEY_D				51
%define KEY_F				52
%define KEY_G				53
%define KEY_H				54
%define KEY_J				55
%define KEY_K				56
%define KEY_L				57
%define KEY_M				58
%define KEY_ACCENTUATED_U	59
%define KEY_ASTERISK		60

%define KEY_LEFT_SHIFT		64
%define KEY_LOWER_THAN		65
%define KEY_W				66
%define KEY_X				67
%define KEY_C				68
%define KEY_V				69
%define KEY_B				70
%define KEY_N				71
%define KEY_COMMA			72
%define KEY_SEMICOLON		73
%define KEY_COLON			74
%define KEY_EXCLAIMATION	75
%define KEY_RIGHT_SHIFT		76

%define KEY_LEFT_CTRL		80
%define KEY_SPACEBAR		84
%define KEY_RIGHT_CTRL		87
%define KEY_UP				88
%define KEY_DOWN			89
%define KEY_LEFT			90
%define KEY_RIGHT			91

%endif
