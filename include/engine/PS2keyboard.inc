%ifndef KEYBOARD_INC
%define KEYBOARD_INC

%include "standard.inc"
%include "LuLib/lutypes.inc"

%define PS2_DATA	0x60
%define PS2_STATUS	0x64
%define PS2_COMMAND	0x64

%define PS2_STATUS_INPUT_BUFFER_FULL	(1 << 0)
%define PS2_STATUS_OUTPUT_BUFFER_FULL	(1 << 1)
%define PS2_STATUS_SYSTEM_FLAG			(1 << 2)
%define PS2_STATUS_COMMAND_DATA_FLAG	(1 << 3)
%define PS2_STATUS_UNK1					(1 << 4)
%define PS2_STATUS_UNK2					(1 << 5)
%define PS2_STATUS_TIMEOUT_FLAG			(1 << 6)
%define PS2_STATUS_PARITY_FLAG			(1 << 7)

;uint32_t scancode
extern scancode
;bool scancode_complete
extern scancode_complete

;void PS2KB_init(uint8_t portID)
extern PS2KB_init
;void PS2KB_read(uint32_t scancode, uint8_t portID)
extern PS2KB_read

;void PS2KB_update(void)
extern PS2KB_update

;bool PS2KB_is_key_pressed(uint8_t keycode)
extern PS2KB_is_key_pressed

;bool PS2KB_is_key_down(uint8_t keycode)
extern PS2KB_is_key_down

;bool PS2KB_is_key_released(uint8_t keycode)
extern PS2KB_is_key_released

;bool PS2KB_is_key_up(uint8_t keycode)
extern PS2KB_is_key_up

;bool PS2KB_is_key_pressed_typematic(uint8_t keycode)
extern PS2KB_is_key_pressed_typematic

;bool PS2KB_is_any_key_pressed(void)
extern PS2KB_is_any_key_pressed

;bool PS2KB_is_any_key_down(void)
extern PS2KB_is_any_key_down

;bool PS2KB_is_any_key_released(void)
extern PS2KB_is_any_key_released

;void PS2KB_char_buffer_flush(void)
extern PS2KB_char_buffer_flush
;char PS2KB_get_char(void)
extern PS2KB_get_char

;void PS2KB_send_command_to_device(uint8_t portID, uint8_t command)
extern PS2KB_send_command_to_device

%define KB_COMMAND_SET_LEDS 0xED
%define KB_COMMAND_ECHO 0xEE
%define KB_COMMAND_GET_SET_SCANCODE_SET 0xF0
%define KB_COMMAND_IDENTIFY 0xF2
%define KB_COMMAND_SET_TYPEMATIC_RATE_DELAY 0xF3
%define KB_COMMAND_ENABLE_SCAN 0xF4
%define KB_COMMAND_DISABLE_SCAN 0xF5
%define KB_COMMAND_DEFAULT_PARAM 0xF6
%define KB_COMMAND_ALL_TYPEMATIC_AUTOREPEAT_ONLY 0xF7 ;scancode set 3 only
%define KB_COMMAND_ALL_MAKE_RELEASE 0xF8 ;scancode set 3 only
%define KB_COMMAND_ALL_MAKE_ONLY 0xF9 ;scancode set 3 only
%define KB_COMMAND_ALL_TYPEMATIC_AUTOREPEAT_MAKE_RELEASE 0xFA ;scancode set 3 only
%define KB_COMMAND_KEY_TYPEMATIC_MAKE_RELEASE 0xFB ;scancode set 3 only
%define KB_COMMAND_KEY_TYPEMATIC_AUTOREPEAT_ONLY 0xFC ;scancode set 3 only
%define KB_COMMAND_KEY_TYPEMATIC_MAKE_ONLY 0xFD ;scancode set 3 only
%define KB_COMMAND_RESEND 0xFE
%define KB_COMMAND_RESTART 0xFF


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
%define KEY_LEFT_ALT        83
%define KEY_SPACEBAR		84
%define KEY_RIGHT_ALT       85
%define KEY_RIGHT_CTRL		87
%define KEY_UP				88
%define KEY_DOWN			89
%define KEY_LEFT			90
%define KEY_RIGHT			91

%define KEY_COUNT			92

%define CHAR_BUFFER_SIZE    4096

%endif ; KEYBOARD_INC
