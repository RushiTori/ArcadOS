bits    64
default rel

%include "main/main.inc"

section .data

%define TEXT_BUFFER_LEN 1024

text_buffer:
static text_buffer:
	db                         "debug"
	times TEXT_BUFFER_LEN-5 db 0

var(static, uint64_t, text_index, 0)

var(static,  uint16_t, pos, 150)
var(static, uint16_t, line_count, 1)

section      .rodata

string(static, ArcadOSTitle, "ArcadOS", 0)

section      .text

; void main_update(void);
func(static, main_update)
	sub rsp, 8 ; to re-align the stack

	call PS2KB_update ; PS2KB_update();

	call update_kb_buffer ; update_kb_buffer();

	mov dx, uint16_p [line_count]
	shl dx, 3
	neg dx

	mov ax, uint16_p [pos]
	inc ax

	cmp    ax,             200
	cmovge ax,             dx
	mov    uint16_p [pos], ax

	add rsp, 8 ; to re-align the stack
	ret

; void main_display(void);
func(static, main_display)
	sub rsp, 8 ; to re-align the stack

	mov  dil, 0x02
	call clear_screen_c ; green screen

	call display_kb_buffer ; display_kb_buffer();

	add rsp, 8 ; to re-align the stack
	ret

func(global, main)
	; Setting up the xmm registers and flloat instructions
		mov rax, cr0
		and ax,  0xFFFB ;clear coprocessor emulation CR0.EM
		or  ax,  0x2    ;set coprocessor monitoring  CR0.MP
		mov cr0, rax
		mov rax, cr4
		or  ax,  3 << 9 ;set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
		mov cr4, rax

	;error test
	;mov rcx, 0
	;div rcx

	.main_loop:
		call main_update
		call main_display

		; mov  rdi, 8192 ; 1 second in rtc_ticks
		; call rtc_sleep_ticks

		mov  rdi, 0              ; seconds
		shl  rdi, 32
		add  rdi, 20 * 1_000_000 ; milliseconds
		add  rdi, 0 * 1_000      ; microseconds
		add  rdi, 0 * 1          ; nanoseconds
		call rtc_sleep

		jmp .main_loop

; void update_kb_buffer(void);
func(static, update_kb_buffer)
	sub rsp, 8 ; to re-align the stack

	.add_to_buffer_loop:
		call PS2KB_get_char          ; PS2KB_get_char();
		cmp  rax, -1
		je   .add_to_buffer_loop_end ; if (PS2KB_get_char() == EOF) break;

		; if (text_index >= TEXT_BUFFER_LEN) break;
		mov rdi,                   uint64_p [text_index]
		cmp uint64_p [text_index], TEXT_BUFFER_LEN
		jge .add_to_buffer_loop_end

		; text_buffer[text_index++] = PS2KB_get_char();
		mov uint8_p [text_buffer + rdi], al
		inc uint64_p [text_index]

		cmp al, FONT_LINE_FEED
		jne .add_to_buffer_loop
		inc uint16_p [line_count]

		jmp .add_to_buffer_loop
	.add_to_buffer_loop_end:

	mov  rdi, KEY_BACKSPACE
	call PS2KB_is_key_pressed ; PS2KB_is_key_pressed(KEY_BACKSPACE);
	cmp  rax, true
	je   .handle_backspace

	mov  rdi, KEY_BACKSPACE
	call PS2KB_is_key_pressed_typematic ; PS2KB_is_key_pressed_typematic(KEY_BACKSPACE);
	cmp  rax, true
	je   .handle_backspace

	jmp .skip_handle_backspace

	.handle_backspace:
		; if (!text_index) goto skip_handle_backspace;
		mov rdi, uint64_p [text_index]
		cmp rdi, 0
		je  .skip_handle_backspace

		; text_buffer[--text_index] = '\0';
		dec uint64_p [text_index]
		mov al,                              uint8_p [text_buffer + rdi]
		mov uint8_p [text_buffer + rdi - 1], 0

		cmp al, FONT_LINE_FEED
		jne .skip_handle_backspace
		dec uint16_p [line_count]

	.skip_handle_backspace:

	add rsp, 8 ; to re-align the stack
	ret

; void display_kb_buffer(void);
func(static, display_kb_buffer)
	sub rsp, 8 ; to re-align the stack

	lea  rdi, [text_buffer]
	xor  rsi, rsi
	xor  rdx, rdx
	mov  dx,  uint16_p [pos]
	call draw_text_and_shadow

	add rsp, 8 ; to re-align the stack
	ret
