bits 64

%include "string.inc"

%include "engine/PS2keyboard.inc"
%include "engine/PS2.inc"
%include "bootloader/pic.inc"

%define KEY_STATE_UNKNOWN  0
%define KEY_STATE_PRESSED  1
%define KEY_STATE_DOWN     2
%define KEY_STATE_RELEASED 3
%define KEY_STATE_UP       4
%define KEY_STATE_TYPEMATIC_PRESSED 5

section .rodata

keymap:
static keymap:data
	; unused	row		column	
	; b			bbb		bbbb
	;
	;
	;  press   release
	dq 0x0076, 0xF076	;escape:						0
	dq 0x0005, 0xF005	;F1:							1
	dq 0x0006, 0xF006	;F2:							2
	dq 0x0004, 0xF004	;F3:							3
	dq 0x000C, 0xF00C	;F4:							4
	dq 0x0005, 0xF005	;F5:							5
	dq 0x000B, 0xF00B	;F6:							6
	dq 0x0083, 0xF083	;F7:							7
	dq 0x000A, 0xF00A	;F8:							8
	dq 0x0001, 0xF001	;F9:							9
	dq 0x0009, 0xF009	;F10:							10
	dq 0x0078, 0xF078	;F11:							11
	dq 0x0007, 0xF007	;F12:							12
	dq 0xE070, 0xE0F070	;insert:						13
	dq 0xE071, 0xE0F071	;delete:						14
	dq 0x0000, 0x0000	;unused							15

	dq 0x000E, 0xF00E	;square symbol:					16
	dq 0x0016, 0xF016 	;one:							17
	dq 0x001E, 0xF01E 	;two:							18
	dq 0x0026, 0xF026 	;three:							19
	dq 0x0025, 0xF025 	;four:							20
	dq 0x002E, 0xF02E 	;five:							21
	dq 0x0036, 0xF036 	;six:							22
	dq 0x003D, 0xF03D 	;seven:							23
	dq 0x003E, 0xF03E 	;eight:							24
	dq 0x0046, 0xF046 	;nine:							25
	dq 0x0045, 0xF045 	;zero:							26
	dq 0x004E, 0xF04E 	;end parenthesis:				27
	dq 0x0055, 0xF055 	;equal sign:					28
	dq 0x0066, 0xF066 	;backspace:						29
	dq 0x0000, 0x0000	;unused							30
	dq 0x0000, 0x0000	;unused							31
	
	dq 0x000D, 0xF00D	;tab:							32
	dq 0x0015, 0xF015	;A:								33
	dq 0x001D, 0xF01D	;Z:								34
	dq 0x0024, 0xF024	;E:								35
	dq 0x002D, 0xF02D	;R:								36
	dq 0x002C, 0xF02C	;T:								37
	dq 0x0035, 0xF035	;Y:								38
	dq 0x003C, 0xF03C	;U:								39
	dq 0x0043, 0xF043	;I:								40
	dq 0x0044, 0xF044	;O:								41
	dq 0x004D, 0xF04D	;P:								42
	dq 0x0054, 0xF054	;caret:							43
	dq 0x005B, 0xF05B	;dollar sign:					44
	dq 0x005A, 0xF05A	;enter:							45
	dq 0x0000, 0x0000	;unused							46
	dq 0x0000, 0x0000	;unused							47

	dq 0x0058, 0xF058	;caps lock:						48
	dq 0x001C, 0xF01C	;Q:								49
	dq 0x001B, 0xF01B	;S:								50
	dq 0x0023, 0xF023	;D:								51
	dq 0x002B, 0xF02B	;F:								52
	dq 0x0034, 0xF034	;G:								53
	dq 0x0033, 0xF033	;H:								54
	dq 0x003B, 0xF03B	;J:								55
	dq 0x0042, 0xF042	;K:								56
	dq 0x004B, 0xF04B	;L:								57
	dq 0x004C, 0xF04C	;M:								58
	dq 0x0052, 0xF052	;u with accent pointing right:	59
	dq 0x005D, 0xF05D	;asterisk:						60
	dq 0x0000, 0x0000	;unused							61
	dq 0x0000, 0x0000	;unused							62
	dq 0x0000, 0x0000	;unused							63
	
	dq 0x0012, 0xF012	;left shift:					64
	dq 0x0061, 0xF061	;lower than:					65
	dq 0x001A, 0xF01A	;W:								66
	dq 0x0022, 0xF022	;X:								67
	dq 0x0021, 0xF021	;C:								68
	dq 0x002A, 0xF02A	;V:								69
	dq 0x0032, 0xF032	;B:								70
	dq 0x0031, 0xF031	;N:								71
	dq 0x003A, 0xF03A	;comma:							72
	dq 0x0041, 0xF041	;semicolon:						73
	dq 0x0049, 0xF049	;colon:							74
	dq 0x004A, 0xF04A	;exclamation mark:				75
	dq 0x005A, 0xF05A	;right shift:					76
	dq 0x0000, 0x0000	;unused							77
	dq 0x0000, 0x0000	;unused							78
	dq 0x0000, 0x0000	;unused							79

	dq 0x0014, 0xF014	;left ctrl:						80
	dq 0, 0				;left fn not mapped
	dq 0, 0				;win not mapped
	dq 0x0011, 0xF011	;alt							83
	dq 0x0029, 0xF029	;space bar:						84
	dq 0xE011, 0xE0F011	;alt gr							85
	dq 0, 0				;right fn not mapped
	dq 0xE014, 0xE0F014	;right control:					87
	dq 0xE075, 0xE0F075	;UP:							88
	dq 0xE072, 0xE0F072	;DOWN:							89
	dq 0xE06B, 0xE0F06B	;LEFT:							90
	dq 0xE074, 0xE0F074	;RIGHT:							91

key_to_char:
static key_to_char:data
	db 0	;escape:						0
	db 0	;F1:							1
	db 0	;F2:							2
	db 0	;F3:							3
	db 0	;F4:							4
	db 0	;F5:							5
	db 0	;F6:							6
	db 0	;F7:							7
	db 0	;F8:							8
	db 0	;F9:							9
	db 0	;F10:							10
	db 0	;F11:							11
	db 0	;F12:							12
	db 0	;insert:						13
	db 0	;delete:						14
	db 0	;unused							15

	db  0	;²:								16
	db '&' 	;ampersand:						17	caps becomes 1
	db '2'	;é:								18	caps becomes 2		alt gr becomes ~
	db 0x22 ;dquote:						19	caps becomes 3		alt gr becomes #
	db 0x27	;apostrophe:					20	caps becomes 4		alt gr becomes {
	db '(' 	;paren start:					21	caps becomes 5		alt gr becomes [
	db '-' 	;dash:							22	caps becomes 6		alt gr becomes |
	db '7'	;è: 							23	caps becomes 7		alt gr becomes `
	db '8' 	;underscore:					24	caps becomes 8		alt gr becomes backslash
	db '9' 	;c with cedille:				25	caps becomes 9		alt gr becomes caret
	db '0'	;à:								26	caps becomes 0		alt gr becomes @
	db ')' 	;paren end:						27	caps becomes °		alt gr becomes ]
	db '=' 	;equal sign:					28	caps becomes +		alt gr becomes }
	db 0	;backspace:						29
	db 0	;unused							30
	db 0	;unused							31
	
	db 0x9	;tab:							32
	db 'a'	;a:								33
	db 'z'	;z:								34
	db 'e'	;e:								35						alt gr becomes €=0X81
	db 'r'	;r:								36
	db 't'	;t:								37
	db 'y'	;y:								38						alt gr becomes yen=0x82
	db 'u'	;u:								39
	db 'i'	;i:								40
	db 'o'	;o:								41
	db 'p'	;p:								42
	db '^'	;caret:							43	caps becomes "
	db '$'	;dollar sign:					44	caps becomes £=0x80	alt gr becomes ¤=0x7F
	db 0xA	;enter:							45
	db 0	;unused							46
	db 0	;unused							47

	db 0	;caps lock:						48
	db 'q'	;q:								49
	db 's'	;s:								50
	db 'd'	;d:								51
	db 'f'	;f:								52
	db 'g'	;g:								53
	db 'h'	;h:								54
	db 'j'	;j:								55
	db 'k'	;k:								56
	db 'l'	;l:								57
	db 'm'	;m:								58
	db  0	;ù with accent pointing right:	59	caps becomes %
	db '*'	;asterisk:						60	caps becomes µ
	db 0	;unused							61
	db 0	;unused							62
	db 0	;unused							63
	
	db 0	;left shift:					64
	db '<'	;lower than:					65
	db 'w'	;w:								66
	db 'x'	;x:								67
	db 'c'	;c:								68						alt gr becomes cent=0x82
	db 'v'	;v:								69
	db 'b'	;b:								70
	db 'n'	;n:								71
	db ','	;comma:							72	caps becomes ?
	db ';'	;semicolon:						73	caps becomes .
	db ':'	;colon:							74	caps becomes /
	db '!'	;exclamation mark:				75	caps becomes §
	db 0	;right shift:					76
	db 0	;unused							77
	db 0	;unused							78
	db 0	;unused							79

	db 0	;left ctrl:						80
	db 0	;left fn not mapped
	db 0	;win not mapped
	db 0	;alt							83
	db ' '	;space bar:						84
	db 0	;alt gr							85
	db 0	;right fn not mapped
	db 0	;right control:					87
	db 0	;UP:							88
	db 0	;DOWN:							89
	db 0	;LEFT:							90
	db 0	;RIGHT:							91

key_to_char_caps:
static key_to_char_caps:data
	db 0	;escape:						0
	db 0	;F1:							1
	db 0	;F2:							2
	db 0	;F3:							3
	db 0	;F4:							4
	db 0	;F5:							5
	db 0	;F6:							6
	db 0	;F7:							7
	db 0	;F8:							8
	db 0	;F9:							9
	db 0	;F10:							10
	db 0	;F11:							11
	db 0	;F12:							12
	db 0	;insert:						13
	db 0	;delete:						14
	db 0	;unused							15

	db  0	;²:								16
	db '1' 	;one:							17
	db '2'	;two:							18	alt gr becomes ~
	db '3' 	;three:							19	alt gr becomes #
	db '4'	;four:							20	alt gr becomes {
	db '5' 	;five:							21	alt gr becomes [
	db '6' 	;six:							22	alt gr becomes |
	db '7'	;seven:							23	alt gr becomes `
	db '8' 	;eight:							24	alt gr becomes \
	db '9' 	;nine:							25	alt gr becomes caret
	db '0'	;zero:							26	alt gr becomes @
	db  0 	;paren end:						27	alt gr becomes ]
	db '+' 	;plus sign:						28	alt gr becomes }
	db 0	;backspace:						29
	db 0	;unused							30
	db 0	;unused							31
	
	db 0x9	;tab:							32
	db 'A'	;A:								33
	db 'Z'	;Z:								34
	db 'E'	;E:								35	alt gr becomes €=0X81
	db 'R'	;R:								36
	db 'T'	;T:								37
	db 'Y'	;Y:								38	alt gr becomes yen=0x82
	db 'U'	;U:								39
	db 'I'	;I:								40
	db 'O'	;O:								41
	db 'P'	;P:								42
	db  0 	;":								43
	db  0	;dollar sign:					44	alt gr becomes ¤=0x7F
	db 0xA	;enter:							45
	db  0	;unused							46
	db  0	;unused							47

	db  0	;caps lock:						48
	db 'Q'	;Q:								49
	db 'S'	;S:								50
	db 'D'	;D:								51
	db 'F'	;F:								52
	db 'G'	;G:								53
	db 'H'	;H:								54
	db 'J'	;J:								55
	db 'K'	;K:								56
	db 'L'	;L:								57
	db 'M'	;M:								58
	db '%'	;ù with accent pointing right:	59	
	db  0	;asterisk:						60	
	db  0	;unused							61
	db  0	;unused							62
	db  0	;unused							63
	
	db  0	;left shift:					64
	db '>'	;lower than:					65
	db 'W'	;W:								66
	db 'X'	;X:								67
	db 'C'	;C:								68						alt gr becomes cent=0x82
	db 'V'	;V:								69
	db 'B'	;B:								70
	db 'N'	;N:								71
	db '?'	;comma:							72	
	db '.'	;semicolon:						73	
	db '/'	;colon:							74	
	db  0	;exclamation mark:				75	
	db  0	;right shift:					76
	db  0	;unused							77
	db  0	;unused							78
	db  0	;unused							79

	db  0	;left ctrl:						80
	db  0	;left fn not mapped
	db  0	;win not mapped
	db  0	;alt							83
	db ' '	;space bar:						84
	db  0	;alt gr							85
	db  0	;right fn not mapped
	db  0	;right control:					87
	db  0	;UP:							88
	db  0	;DOWN:							89
	db  0 	;LEFT:							90
	db  0	;RIGHT:							91

key_to_char_alt_gr:
static key_to_char_alt_gr:data
	db 0	;escape:						0
	db 0	;F1:							1
	db 0	;F2:							2
	db 0	;F3:							3
	db 0	;F4:							4
	db 0	;F5:							5
	db 0	;F6:							6
	db 0	;F7:							7
	db 0	;F8:							8
	db 0	;F9:							9
	db 0	;F10:							10
	db 0	;F11:							11
	db 0	;F12:							12
	db 0	;insert:						13
	db 0	;delete:						14
	db 0	;unused							15

	db  0	;²:								16
	db '&' 	;ampersand:						17	caps becomes 1
	db '2'	;é:								18	caps becomes 2		alt gr becomes ~
	db 0x22 ;dquote:						19	caps becomes 3		alt gr becomes #
	db 0x27	;apostrophe:					20	caps becomes 4		alt gr becomes {
	db '(' 	;paren start:					21	caps becomes 5		alt gr becomes [
	db '-' 	;dash:							22	caps becomes 6		alt gr becomes |
	db '7'	;è: 							23	caps becomes 7		alt gr becomes `
	db '_' 	;underscore:					24	caps becomes 8		alt gr becomes \
	db '9' 	;c with cedille:				25	caps becomes 9		alt gr becomes ^
	db '0'	;à:								26	caps becomes 0		alt gr becomes @
	db ')' 	;paren end:						27	caps becomes °		alt gr becomes ]
	db '=' 	;equal sign:					28	caps becomes +		alt gr becomes }
	db 0	;backspace:						29
	db 0	;unused							30
	db 0	;unused							31
	
	db 0x9	;tab:							32
	db 'a'	;a:								33
	db 'z'	;z:								34
	db 'e'	;e:								35						alt gr becomes €=0X81
	db 'r'	;r:								36
	db 't'	;t:								37
	db 'y'	;y:								38						alt gr becomes yen=0x82
	db 'u'	;u:								39
	db 'i'	;i:								40
	db 'o'	;o:								41
	db 'p'	;p:								42
	db '^'	;caret:							43	caps becomes "
	db '$'	;dollar sign:					44	caps becomes £=0x80	alt gr becomes ¤=0x7F
	db 0xA	;enter:							45
	db 0	;unused							46
	db 0	;unused							47

	db 0	;caps lock:						48
	db 'q'	;q:								49
	db 's'	;s:								50
	db 'd'	;d:								51
	db 'f'	;f:								52
	db 'g'	;g:								53
	db 'h'	;h:								54
	db 'j'	;j:								55
	db 'k'	;k:								56
	db 'l'	;l:								57
	db 'm'	;m:								58
	db  0	;ù with accent pointing right:	59	caps becomes %
	db '*'	;asterisk:						60	caps becomes µ
	db 0	;unused							61
	db 0	;unused							62
	db 0	;unused							63
	
	db 0	;left shift:					64
	db '<'	;lower than:					65
	db 'w'	;w:								66
	db 'x'	;x:								67
	db 'c'	;c:								68						alt gr becomes cent=0x82
	db 'v'	;v:								69
	db 'b'	;b:								70
	db 'n'	;n:								71
	db ','	;comma:							72	caps becomes ?
	db ';'	;semicolon:						73	caps becomes .
	db ':'	;colon:							74	caps becomes /
	db '!'	;exclamation mark:				75	caps becomes §
	db 0	;right shift:					76
	db 0	;unused							77
	db 0	;unused							78
	db 0	;unused							79

	db 0	;left ctrl:						80
	db 0	;left fn not mapped
	db 0	;win not mapped
	db 0	;alt							83
	db ' '	;space bar:						84
	db 0	;alt gr							85
	db 0	;right fn not mapped
	db 0	;right control:					87
	db 0	;UP:							88
	db 0	;DOWN:							89
	db 0	;LEFT:							90

section .bss

res(global, bool_t, scancode_complete)

res(global, uint64_t, scancode)

res_array(static, uint8_t, IRQ_key_states, KEY_COUNT)

res_array(global, uint8_t, key_states, KEY_COUNT)

res_array(static, uint8_t, char_buffer, CHAR_BUFFER_SIZE)

res(static, uint64_t, char_buffer_idx)

res(global, bool_t, is_scroll_locked)
res(global, bool_t, is_caps_locked)
res(global, bool_t, is_numpad_locked)

res(static, uint8_t, current_port_ID)

section .text

;void wait_for_response(void)
func(static, PS2KB_wait_for_response)
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	jz PS2KB_wait_for_response
	ret
;void wait_for_sending(void)
func(static, PS2KB_wait_for_sending)
	in al, PS2_STATUS
	and al, PS2_STATUS_OUTPUT_BUFFER_FULL
	jnz PS2KB_wait_for_sending
	ret
;warning: masks all interrupt
;void PS2KB_init(uint8_t portID)
func(global, PS2KB_init)
	mov byte [current_port_ID], dil ;store the port we're initializing for

	mov rdi, 0xFE
	mov rsi, 0xFE
	call mask_pic64

	mov dil, byte [current_port_ID]
	mov rsi, KB_COMMAND_GET_SET_SCANCODE_SET
	call PS2KB_send_command_to_device

	mov dil, byte [current_port_ID]
	mov rsi, 2 ;set 2
	call PS2KB_send_command_to_device

	mov al, false
	mov [is_scroll_locked], al
	mov [is_caps_locked], al
	mov [is_numpad_locked], al

	mov rcx, KEY_COUNT

	.clear_keys:
		mov byte [key_states + rcx - 1], KEY_STATE_UP
		mov byte [IRQ_key_states + rcx - 1], KEY_STATE_UNKNOWN
		loop .clear_keys


	mov rdi, 0xFF
	mov rsi, 0xFF
	call mask_pic64

	mov dil, byte [current_port_ID]
	mov rsi, KB_COMMAND_SET_TYPEMATIC_RATE_DELAY
	call PS2KB_send_command_to_device
	cmp rax, -1
	je .end

	mov dil, byte [current_port_ID]
			  ;z_dd_rrrrr where z must be zero, d is delay in a range of 250 to 1000ms (0 is 250ms) (included on both ends), and rrrrr is a repeat rate, from 2 Hz to 30Hz (0 is 30Hz) (included on both ends)
	mov rsi, 0b0_01_00000 ;here 500 ms with a repeat rate of 30Hz, sounds good
	call PS2KB_send_command_to_device
	cmp rax, -1
	je .end

	.end:
	ret

	.error:
	jmp $
;void PS2KB_read(uint32_t scancode, uint8_t portID)
func(global, PS2KB_read)
	mov byte [current_port_ID], dil

	xor rax, rax

	cmp byte[scancode_complete], false
	je .skip_reset_scancode
		mov qword[scancode], 0
	.skip_reset_scancode:

	in al, PS2_DATA
	cmp al, 0xFA
	je .endRead

	mov rcx, qword[scancode]
	shl rcx, 8
	or rax, rcx
	mov qword[scancode], rax

	cmp al, 0xE0
	je .await_next_keystate
	cmp al, 0xF0
	je .await_next_keystate

	mov byte[scancode_complete], true
	call PS2KB_IRQ_handler_update
	jmp .endRead

	.await_next_keystate:
		mov byte[scancode_complete], false
	.endRead:
	
	ret

;uint8_t PS2KB_scancode_to_keycode(uint32_t scancode)
func(static, PS2KB_scancode_to_keycode)
	xor rcx, rcx
	.lookup_loop:
		cmp rdi, qword[keymap + rcx * 8]
		je .end
		inc rcx
		cmp rcx, KEY_COUNT * 2 ;multiply by 2 because there's pressed key and released key for scancodes
		jae .end
		jmp .lookup_loop
	.end:
	mov rax, rcx
	shr rax, 1

	and rcx, 1
	mov ah, cl

	ret

;char PS2KB_keycode_to_char(uint32_t keycode)
func(static, PS2KB_keycode_to_char)

	push rdi

	mov rdi, KEY_RIGHT_ALT
	call PS2KB_is_key_pressed
	mov rcx, rax

	mov rdi, KEY_RIGHT_ALT
	call PS2KB_is_key_down
	or rcx, rax
	jnz .alt_gr_handling

	mov rdi, KEY_LEFT_SHIFT
	call PS2KB_is_key_pressed
	mov rcx, rax

	mov rdi, KEY_LEFT_SHIFT
	call PS2KB_is_key_down
	or rcx, rax

	mov rdi, KEY_RIGHT_SHIFT
	call PS2KB_is_key_pressed
	or rcx, rax

	mov rdi, KEY_RIGHT_SHIFT
	call PS2KB_is_key_down
	or rcx, rax
	jnz .caps_handling

	.regular_handling:
		pop rdi
		movzx rax, byte[key_to_char + rdi]
		jmp .end

	.caps_handling:
		pop rdi
		movzx rax, byte[key_to_char_caps + rdi]
		jmp .end

	.alt_gr_handling:
		pop rdi
		movzx rax, byte[key_to_char_alt_gr + rdi]
	.end:
	ret


;warning, to update so that it uses the correct port probably
;void PS2KB_flush(void)
func(static, PS2KB_flush)
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	je .end
	in al, PS2_DATA
	jmp PS2KB_flush
	.end:
	ret

;void PS2KB_IRQ_handler_update(void)
func(static, PS2KB_IRQ_handler_update)
	mov rdi, qword[scancode]
	call PS2KB_scancode_to_keycode
	cmp al, KEY_COUNT
	jge .end

	cmp ah, false
	je .writepress
	.writerelease:
		movzx rdi, al
		mov byte[IRQ_key_states + rdi], KEY_STATE_RELEASED
		jmp .end
	.writepress:
		movzx rdi, al
		mov byte[IRQ_key_states + rdi], KEY_STATE_PRESSED
	

		cmp rdi, KEY_CAPS_LOCK
		jne .skipCapsLockHandling

		xor byte [is_caps_locked], 1
		call PS2KB_LEDs_update
	.skipCapsLockHandling:

	;rdi already holds keycode
		call PS2KB_keycode_to_char
		cmp rax, 0
		je .skipTextWrite
		mov rsi, [char_buffer_idx]
		cmp rsi, CHAR_BUFFER_SIZE - 1
		jge .skipTextWrite
		mov byte [char_buffer + rsi], al
		inc qword [char_buffer_idx]
	.skipTextWrite:
	.end:
	ret

;void PS2KB_LEDs_update(void)
func(static, PS2KB_LEDs_update)
	mov dil, byte [current_port_ID]
	mov sil, 0xED
	call PS2KB_send_command_to_device
	cmp rax, -1
	je .error

	;cns where n is numpad lock, c is caps lock, and s is scroll lock
	mov al, byte [is_scroll_locked]
	mov sil, al
	mov al, byte [is_numpad_locked]
	shl al, 1
	or sil, al
	mov al, byte [is_caps_locked]
	shl al, 2
	or sil, al
	mov dil, byte [current_port_ID]
	call PS2KB_send_command_to_device
	cmp rax, -1
	je .error

	ret

	.error:
	jmp $

;void PS2KB_char_buffer_flush(void)
func(global, PS2KB_char_buffer_flush)
	mov qword [char_buffer_idx], 0
	ret

;char PS2KB_get_char(void)
func(global, PS2KB_get_char)
	mov al, 0
	mov rsi, [char_buffer_idx]
	cmp rsi, 0
	mov rax, -1
	jz .end

	mov rax, [char_buffer]
	push rax

	mov rdi, char_buffer
	mov rdx, CHAR_BUFFER_SIZE
	sub rdx, rsi
	add rsi, char_buffer
	call memmove

	pop rax

	mov qword [char_buffer_idx], 0
	.end:
	ret

;void PS2KB_update(void)
func(global, PS2KB_update)

	; WIP

	xor rdi, rdi
	mov rcx, KEY_COUNT
	.update_loop:
		mov al, byte[IRQ_key_states + rdi]
		cmp al, KEY_STATE_UNKNOWN
		je .update_key_status

		cmp al, KEY_STATE_RELEASED
		je .handle_released
		.handle_pressed:
			.put_state_pressed:
			cmp byte[key_states + rdi], KEY_STATE_DOWN
			je .put_state_typematic_pressed
			mov byte[key_states + rdi], KEY_STATE_PRESSED
			jmp .continue_update_loop

			.put_state_typematic_pressed:
			mov byte[key_states + rdi], KEY_STATE_TYPEMATIC_PRESSED
			jmp .continue_update_loop

		.handle_released:
			.put_state_released:
			mov byte[key_states + rdi], KEY_STATE_RELEASED
			jmp .continue_update_loop

		.put_state_down:
			mov byte [key_states + rdi], KEY_STATE_DOWN
			jmp .continue_update_loop

		.put_state_up:
			mov byte [key_states + rdi], KEY_STATE_UP
			jmp .continue_update_loop

		.update_key_status:
			cmp byte[key_states + rdi], KEY_STATE_TYPEMATIC_PRESSED
			je .put_state_down
			cmp byte[key_states + rdi], KEY_STATE_PRESSED
			je .put_state_down
			cmp byte[key_states + rdi], KEY_STATE_RELEASED
			je .put_state_up
		.continue_update_loop:
		mov byte[IRQ_key_states + rdi], KEY_STATE_UNKNOWN
		inc rdi
		loop .update_loop

	ret
		; Logic to translate
		;	if (isPressed) {
		;		if (state == InputState::Pressed)
		;			state = InputState::Down;
		;		else if (state == InputState::Released || state == InputState::Up)
		;			state = InputState::Pressed;
		;	} else {
		;		if (state == InputState::Released)
		;			state = InputState::Up;
		;		else if (state == InputState::Pressed || state == InputState::Down)
		;			state = InputState::Released;
		;	}

;bool PS2KB_is_key_pressed(uint8_t keycode)
func(global, PS2KB_is_key_pressed)
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_PRESSED
	jne .end
	inc rax

	.end:
	ret
;bool PS2KB_is_key_pressed_typematic(uint8_t keycode)
func(global, PS2KB_is_key_pressed_typematic)
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_TYPEMATIC_PRESSED
	jne .end
	inc rax

	.end:
	ret

;bool PS2KB_is_key_down(uint8_t keycode)
func(global, PS2KB_is_key_down)
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_TYPEMATIC_PRESSED
	je .end
	cmp dil, KEY_STATE_DOWN
	jne .end
	.true:
		inc rax

	.end:
	ret

;bool PS2KB_is_key_released(uint8_t keycode)
func(global, PS2KB_is_key_released)
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_RELEASED
	jne .end
	inc rax

	.end:
	ret

;bool PS2KB_is_key_up(uint8_t keycode)
func(global, PS2KB_is_key_up)
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_UP
	jne .end
	inc rax
	
	.end:
	ret

;bool PS2KB_is_any_key_pressed(void)
func(global, PS2KB_is_any_key_pressed)
	;jmp $
	xor rax, rax
	mov rcx, KEY_COUNT
	mov rdi, 0
	.loop:
		mov al, uint8_p [key_states + rdi - 1]
		cmp al, 1
		je .true
		inc rdi
		dec rcx
		jne .loop
	.false:
		mov rax, false
		ret
	.true:
		mov rax, true
		ret

;bool PS2KB_is_any_key_down(void)
func(global, PS2KB_is_any_key_down)
	xor rax, rax
	mov rcx, KEY_COUNT
	mov rdi, 0
	.loop:
		cmp uint8_p [key_states + rdi - 1], KEY_STATE_DOWN
		je .true
		dec rcx
		jne .loop
	.false:
		mov rax, 0
		ret
	.true:
		mov rax, 1
		ret
;bool PS2KB_is_any_key_released(void)
func(global, PS2KB_is_any_key_released)
	xor rax, rax
	mov rcx, KEY_COUNT
	mov rdi, 0
	.loop:
		cmp uint8_p [key_states + rdi - 1], KEY_STATE_RELEASED
		je .true
		dec rcx
		jne .loop
	.false:
		mov rax, 0
		ret
	.true:
		mov rax, 1
		ret
;void PS2KB_send_command_to_device(uint8_t portID, uint8_t command)
func(global, PS2KB_send_command_to_device)
	cmp rdi, 1
	je .handle_port2

	mov rdi, rsi
	call PS2KB_send_command_to_port1
	jmp .end
	.handle_port2:
		mov rdi, rsi
		call PS2KB_send_command_to_port2
	.end:
	ret

;void PS2KB_send_command_to_port1(uint8_t command)
func(static, PS2KB_send_command_to_port1)
	xor rcx, rcx
	.resend:
		mov al, dil
		out PS2_DATA, al
		call PS2KB_wait_for_sending
		call PS2KB_wait_for_response

		in al, PS2_DATA
		cmp al, RESPONSE_RESEND
		je .resend_handler
		cmp al, RESPONSE_ACK
		mov rax, 0
		je .end
		jmp .error
	.resend_handler:
		inc rcx
		cmp rcx, 3
		jl .resend
		jmp .error
	.end:
	ret
	.error:
	jmp $

;void PS2KB_send_command_to_port2(uint8_t command)
func(static, PS2KB_send_command_to_port2)
	xor rcx, rcx
	.resend:
		mov al, PS2_COMMAND_WRITE_BYTE_PORT2
		out PS2_COMMAND, al
		mov al, dil
		out PS2_DATA, al
		call PS2KB_wait_for_sending
		call PS2KB_wait_for_response

		in al, PS2_DATA
		cmp al, RESPONSE_RESEND
		je .resend_handler
		cmp al, RESPONSE_ACK
		mov rax, 0
		je .end
		jmp .error
	.resend_handler:
		inc rcx
		cmp rcx, 3
		jl .resend
		jmp .error
	.end:
	ret
	.error:
	jmp $