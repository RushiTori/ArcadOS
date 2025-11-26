%include "engine/PS2.inc"
%include "engine/PS2keyboard.inc"
%include "engine/font.inc"
%include "engine/PIT_timer.inc"

section .rodata

string(static, error_init_controller_error, "PS/2 error: controller self test", 0xA, "failed!", 0)

string(static, error_port1_check, "PS/2 error: port 1 test failed!", 0)
string(static, error_port2_check, "PS/2 error: port 2 test failed!", 0)

string(static, error_port1_id_reception, "PS/2 error: could not obtain", 0xA, "port 1 device id!", 0)
string(static, error_port2_id_reception, "PS/2 error: could not obtain", 0xA, "port 2 device id!", 0)

string(static, error_disable_scan_port1, "PS/2 error: could not disable", 0xA, "scanning on port 1!", 0)
string(static, error_disable_scan_port2, "PS/2 error: could not disable", 0xA, "scanning on port 2!", 0)

string(static, error_enable_scan_port1, "PS/2 error: could not enable", 0xA, "scanning on port 1!", 0)
string(static, error_enable_scan_port2, "PS/2 error: could not enable", 0xA, "scanning on port 2!", 0)

string(static, error_port_not_populated_maybe_port1, "PS/2 error: no ID fetch on port 1!", 0)
string(static, error_port_not_populated_maybe_port2, "PS/2 error: no ID fetch on port 2!", 0)

string(static, warning_no_PS2_devices, "no PS/2 devices were detected", 0xA, "by the driver!", 0xA, "the OS will not proceed, please shut down the computer, plug in a PS/2 keyboard", 0xA, "and start it up again.", 0)

section .bss

res(static, bool_t, PS2_port_2)

res(static, uint8_t, PS2_port_1_state)
res(static, uint8_t, PS2_port_2_state)

PS2_device_array:
static PS2_device_array: data
PS2_port_1_device:
	resw 1
PS2_port_2_device:
	resw 1

res(static, uint64_t, PS2_timeout_timer)

section .text

;might change later, depends on if i handle the boring and complicated stuff later
;void PS2_init(void)
func(global, PS2_init)
	;skipping step 1 and step 2, too lazy to rewrite ACPI stuff

	;step 3
    ;disable devices

    ;call PS2_wait_for_sending
    mov al,          PS2_COMMAND_DISABLE_PORT1
    out PS2_COMMAND, al

    ;call PS2_wait_for_sending
    mov al,          PS2_COMMAND_DISABLE_PORT2
    out PS2_COMMAND, al

    ;call PS2_wait_for_sending
	;step 4
    call PS2_flush

	;step 5
    mov al,          PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al
    ;call PS2_wait_for_sending

	call PS2_wait_for_response
    in   al, PS2_DATA

	and al, ~(PS2_CONFIGURATION_PORT1_INTERRUPT | PS2_CONFIGURATION_PORT1_CLOCK | PS2_CONFIGURATION_PORT1_TRANSLATE)
	mov ah, al

	mov al,          PS2_COMMAND_WRITE_CONFIG_BYTE
	out PS2_COMMAND, al
	;call PS2_wait_for_sending

	mov  al,       ah
	out  PS2_DATA, al
	call PS2_wait_for_sending ;send back new flags

	;now do step 6
	mov al,          PS2_COMMAND_TEST_CONTROLLER
	out PS2_COMMAND, al

	call PS2_wait_for_response
	in   al, PS2_DATA
	cmp  al, PS2_CONTROLLER_TEST_SUCCESSFUL
	jne  .error_controller_test

	;step 7
	mov al,          PS2_COMMAND_ENABLE_PORT2
	out PS2_COMMAND, al

	mov al,          PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al

	call PS2_wait_for_response
	in   al, PS2_DATA
	and  al, PS2_CONFIGURATION_PORT2_CLOCK
	jz   .dual_port
		mov byte [PS2_port_2], false
		jmp .end_port_check
	.dual_port:
		mov byte [PS2_port_2], true
	.end_port_check:

	;step 8
	mov  al,                      PS2_COMMAND_TEST_PORT1
	out  PS2_COMMAND,             al
	call PS2_wait_for_response
	in   al,                      PS2_DATA
	mov  byte [PS2_port_1_state], al
	cmp  al,                      PORT_STATE_SUCCESS
	jne  .error_port1_failed
	cmp  byte [PS2_port_2],       true
	jne  .skip_port2_test

		mov  al,                      PS2_COMMAND_TEST_PORT2
		out  PS2_COMMAND,             al
		call PS2_wait_for_response
		in   al,                      PS2_DATA
		mov  byte [PS2_port_2_state], al
		cmp  al,                      PORT_STATE_SUCCESS
		jne  .error_port2_failed
	.skip_port2_test:

	;step 9
	mov al,          PS2_COMMAND_ENABLE_PORT1
	out PS2_COMMAND, al

	mov al,          PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al

	call PS2_wait_for_response
	in   al, PS2_DATA
	or   al, PS2_CONFIGURATION_PORT1_INTERRUPT
	mov  ah, al

	cmp byte [PS2_port_2], true
	jne .skip_port2_enable
		mov al,          PS2_COMMAND_ENABLE_PORT2
		out PS2_COMMAND, al

		or ah, PS2_CONFIGURATION_PORT2_INTERRUPT
	.skip_port2_enable:
	mov al,          PS2_COMMAND_WRITE_CONFIG_BYTE
	out PS2_COMMAND, al

	mov  al,       ah
	out  PS2_DATA, al
	call PS2_wait_for_sending

	;step 10
	mov  al,       PS2_DEVICE_COMMAND_RESET
	out  PS2_DATA, al
	call PS2_wait_for_sending

	call PS2_wait_for_response
	cmp  rax, -1
	je   .no_ID_port1
	in   al,  PS2_DATA

	cmp al, 0xFA
	je  .check_AA_Port1

	cmp al, 0xAA
	je  .check_FA_Port1

	cmp al, 0xFC
	je  .error_port1_id

	;port not populated
	mov ax,                  0xFFFF
	mov [PS2_port_1_device], ax
	jmp .end_get_device_ID_port1

	.check_AA_Port1:
		call PS2_wait_for_response
		cmp  rax, -1
		je   .no_ID_port1
		in   al,  PS2_DATA

		cmp al, 0xAA
		jne .error_port1_id
		jmp .get_device_id_port1
	.check_FA_Port1:
		call PS2_wait_for_response
		in   al, PS2_DATA

		cmp al, 0xFA
		jne .error_port1_id
		jmp .get_device_id_port1
	.get_device_id_port1:
		call PS2_wait_for_response
		in   al, PS2_DATA
		
		mov  ah,  al
		xor  al,  al
		push rax
		call PS2_wait_for_response
		cmp  rax, -1
		pop  rax
		je   .write_data_port1

		in al, PS2_DATA
	.write_data_port1:
		mov [PS2_port_1_device], ax
		jmp .end_get_device_ID_port1
	.nothing_port1:
		mov ax,                  0xFFFF
		mov [PS2_port_1_device], ax
		jmp .end_get_device_ID_port1
	.no_ID_port1:
		mov ax,                  0xFFFE
		mov [PS2_port_1_device], ax
	.end_get_device_ID_port1:

	mov al, [PS2_port_2]
	cmp al, true
	jne .end_get_device_ID_port2

	mov  al,          PS2_COMMAND_WRITE_BYTE_PORT2
	out  PS2_COMMAND, al
	mov  al,          PS2_DEVICE_COMMAND_RESET
	out  PS2_DATA,    al
	call PS2_wait_for_sending

	call PS2_wait_for_response
	cmp  rax, -1
	je   .nothing_port2
	in   al,  PS2_DATA

	cmp al, 0xFA
	je  .check_AA_port2

	cmp al, 0xAA
	je  .check_FA_port2

	cmp al, 0xFC
	je  .error_port2_id

	;port not populated
	mov ax,                  0xFFFF
	mov [PS2_port_2_device], ax
	jmp .end_get_device_ID_port2

	.check_AA_port2:
		call PS2_wait_for_response
		cmp  rax, -1
		je   .no_ID_port2
		in   al,  PS2_DATA

		cmp al, 0xAA
		jne .error_port2_id
		jmp .get_device_ID_port2
	.check_FA_port2:
		call PS2_wait_for_response
		in   al, PS2_DATA

		cmp al, 0xFA
		jne .error_port2_id
		jmp .get_device_ID_port2
	.get_device_ID_port2:
		call PS2_wait_for_response
		in   al, PS2_DATA
		
		mov  ah,  al
		xor  al,  al
		push rax
		call PS2_wait_for_response
		cmp  rax, -1
		pop  rax
		je   .write_data_port2

		in al, PS2_DATA
	.write_data_port2:
		mov [PS2_port_2_device], ax
		jmp .end_get_device_ID_port2
	.nothing_port2:
		mov ax,                  0xFFFF
		mov [PS2_port_2_device], ax
		jmp .end_get_device_ID_port2
	.no_ID_port2:
		mov ax,                  0xFFFE
		mov [PS2_port_2_device], ax
	.end_get_device_ID_port2:
	call PS2_get_devices_ID

	;mov al, PS2_COMMAND_READ_CONFIG_BYTE
	;out PS2_COMMAND, al

	;call PS2_wait_for_response

	;mov cl, al
	;mov al, PS2_COMMAND_WRITE_CONFIG_BYTE
	;out PS2_COMMAND, al

	;call PS2_wait_for_response

	;mov al, cl
	;out PS2_DATA, al

	mov ax, word [PS2_port_1_device]
		;mices
	cmp ax, 0x0000
	je  .mouse_init1
	cmp ax, 0x0300
	je  .mouse_init1
	cmp ax, 0x0400
	je  .mouse_init1

	;keyboards
	cmp ax, 0xFFFE
	je  .KB_init1
	cmp ax, 0xAB83
	je  .KB_init1
	cmp ax, 0xABC1
	je  .KB_init1
	cmp ax, 0xAB84
	je  .KB_init1
	cmp ax, 0xAB85
	je  .KB_init1
	cmp ax, 0xAB86
	je  .KB_init1
	cmp ax, 0xAB90
	je  .KB_init1
	cmp ax, 0xAB91
	je  .KB_init1
	cmp ax, 0xAB92
	je  .KB_init1
	cmp ax, 0xACA1
	je  .KB_init1
	jmp .end_init_port1 ;unsupported device

	.mouse_init1:
		jmp .end_init_port1 ;not supported yet, no driver

	.KB_init1:
		mov  rdi, 0
		call PS2KB_init

	.end_init_port1:
	mov ax, word [PS2_port_2_device]
	;mices
	cmp ax, 0x0000
	je  .mouse_init2
	cmp ax, 0x0300
	je  .mouse_init2
	cmp ax, 0x0400
	je  .mouse_init2

	;keyboards
	cmp ax, 0xFFFE
	je  .KB_init2
	cmp ax, 0xAB83
	je  .KB_init2
	cmp ax, 0xABC1
	je  .KB_init2
	cmp ax, 0xAB84
	je  .KB_init2
	cmp ax, 0xAB85
	je  .KB_init2
	cmp ax, 0xAB86
	je  .KB_init2
	cmp ax, 0xAB90
	je  .KB_init2
	cmp ax, 0xAB91
	je  .KB_init2
	cmp ax, 0xAB92
	je  .KB_init2
	cmp ax, 0xACA1
	je  .KB_init2
	jmp .end_init_port2 ;unsupported device

	.mouse_init2:
		jmp .end_init_port2 ;not supported yet, no driver

	.KB_init2:
		mov  rdi, 1
		call PS2KB_init
	.end_init_port2:

	ret
	.error_controller_test:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_init_controller_error
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_init_controller_error, 0, 0);

		jmp $ ; halt due to error

	.error_port1_failed:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_port1_check
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_port1_check, 0, 0);

		jmp $ ; halt due to error

	.error_port2_failed:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_port2_check
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_port2_check, 0, 0);

		jmp $ ; halt due to error

	.error_port1_id:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_port1_id_reception
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_port1_id_reception, 0, 0);

		jmp $ ; halt due to error

	.error_port2_id:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_port2_id_reception
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_port2_id_reception, 0, 0);

		jmp $ ; halt due to error

;void PS2_get_devices_ID(void)
func(static, PS2_get_devices_ID)
	mov  dil, PS2_DEVICE_COMMAND_DISABLE_SCAN
	call PS2_send_command_to_port1
	cmp  rax, -1
	je   .port1_not_populated

	mov  dil, PS2_DEVICE_COMMAND_IDENTIFY
	call PS2_send_command_to_port1

	call PS2_wait_for_response
	cmp  rax, -1
	je   .no_code_port1

	in   al,  PS2_DATA
	xor  ah,  ah
	push rax
	call PS2_wait_for_response
	cmp  rax, -1
	pop  rax
	je   .end_code_port1
	mov  ah,  al
	in   al,  PS2_DATA
	jmp  .end_code_port1
	.no_code_port1:
		mov ax, 0xFFFE
		jmp .end_code_port1
	.port1_not_populated:
		mov ax,                       0xFFFF
		mov word [PS2_port_1_device], ax
		jmp .try_port2
	.end_code_port1:
		mov word [PS2_port_1_device], ax

	mov  dil, PS2_DEVICE_COMMAND_ENABLE_SCAN
	call PS2_send_command_to_port1

	;todo: check if port2 exists, if not, skip the code below with a good old 0xFFFF for device 2

	.try_port2:
	mov  dil, PS2_DEVICE_COMMAND_DISABLE_SCAN
	call PS2_send_command_to_port2
	cmp rax, -1
	je	.port2_not_populated

	mov  dil, PS2_DEVICE_COMMAND_IDENTIFY
	call PS2_send_command_to_port2

	call PS2_wait_for_response
	cmp  rax, -1
	je   .nocode_port2

	in   al,  PS2_DATA
	xor  ah,  ah
	push rax
	call PS2_wait_for_response
	cmp  rax, -1
	pop  rax
	je   .endcode_port2
	mov  ah,  al
	in   al,  PS2_DATA
	jmp  .endcode_port2
	.nocode_port2:
		mov ax, 0xFFFE
		jmp .endcode_port2
	.port2_not_populated:
		mov ax,                       0xFFFF
		mov word [PS2_port_2_device], ax
		jmp .end
	.endcode_port2:
		mov word [PS2_port_2_device], ax

		mov  dil, PS2_DEVICE_COMMAND_ENABLE_SCAN
		call PS2_send_command_to_port2
	.end:

	mov ax, [PS2_port_1_device]
	mov bx, [PS2_port_2_device]

	cmp ax, bx
	jne .end_check

	cmp ax, 0xFFFF
	jne .end_check

		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, warning_no_PS2_devices
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(warning_no_PS2_devices, 0, 0);

		jmp $ ; halt due to error
	.end_check:

	ret
	.error_enable_scan_port1:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_enable_scan_port1
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_enable_scan_port1, 0, 0);

		jmp $ ; halt due to error
	.error_enable_scan_port2:
		mov  dil, 0x01      ; some kind of blue
		call clear_screen_c ; clear_screen_c(blue_01);

		mov rdi, error_enable_scan_port2
		xor si,  si
		xor dx,  dx

		call draw_text ; draw_text(error_enable_scan_port2, 0, 0);

		jmp $ ; halt due to error

;returns -1 on timeout, returns 0 else, hangs if timer creation fails
;int64_t PS2_send_command_to_port1(uint8_t data)
func(global, PS2_send_command_to_port1)
	xor rcx, rcx
	.resend:
		mov  al,       dil
		out  PS2_DATA, al
		call PS2_wait_for_sending
		call PS2_wait_for_response
		cmp  rax,      -1
		je   .timeout

		in  al,  PS2_DATA
		cmp al,  RESPONSE_RESEND
		je  .resend_handler
	cmp al,  RESPONSE_ACK
	mov rax, 0
	je  .end
	jmp .error
	.resend_handler:
		inc rcx
		cmp rcx, 3
		jl  .resend
		jmp .error

	.timeout:
	mov rax, -1
	.end:
	ret
	.error:
		jmp $

;returns -1 on timeout, returns 0 else, hangs if timer creation fails
;int64_t PS2_send_command_to_port2(uint8_t data)
func(global, PS2_send_command_to_port2)
	xor rcx, rcx
	.resend:
		mov  al,          PS2_COMMAND_WRITE_BYTE_PORT2
		out  PS2_COMMAND, al
		mov  al,          dil
		out  PS2_DATA,    al
		call PS2_wait_for_sending
		call PS2_wait_for_response
		cmp  rax,         -1
		je   .timeout

		in  al,  PS2_DATA
		cmp al,  RESPONSE_RESEND
		je  .resend_handler
	cmp al,  RESPONSE_ACK
	mov rax, 0
	je  .end
	jmp .error
	.resend_handler:
		inc rcx
		cmp rcx, 3
		jl  .resend
		jmp .error
	
	.timeout:
	mov rax, -1
	.end:
	ret
	.error:
		jmp $

;returns -1 on timeout, returns 0 else, hangs if timer creation fails
;int64_t PS2_wait_for_response(void)
func(static, PS2_wait_for_response)
	call create_timer
	cmp  rax,                       -1
	je   .error
	mov  qword [PS2_timeout_timer], rax
	.loop:
		mov  rdi, qword [PS2_timeout_timer]
		call get_timer_ms
		shr  rax, 32
		cmp  rax, 5
		jge  .timeout

		in  al, PS2_STATUS
		and al, PS2_STATUS_INPUT_BUFFER_FULL
		jz  .loop

	mov rax, 0
	jmp .end

	.timeout:
		mov rax, -1
	.end:
		push rax
		mov  rdi, qword [PS2_timeout_timer]
		call remove_timer
		pop  rax
	ret
	.error:
		jmp $ ;timer creation failed

;returns -1 on timeout, returns 0 else, hangs if timer creation fails
;int64_t PS2_wait_for_sending(void)
func(static, PS2_wait_for_sending)
	call create_timer
	cmp  rax,                       -1
	je   .error
	mov  qword [PS2_timeout_timer], rax
	.loop:
		mov  rdi, qword [PS2_timeout_timer]
		call get_timer_ms
		shr  rax, 32
		cmp  rax, 5
		jge  .timeout

		in  al,  PS2_STATUS
		and al,  PS2_STATUS_OUTPUT_BUFFER_FULL
		jnz .loop
	mov rax, 0
	jmp .end
	.timeout:
		mov  rdi, qword [PS2_timeout_timer]
		call remove_timer
		mov  rax, -1
	.end:
	ret
	.error:
		jmp $ ;timer creation failed

func(static, PS2_flush)
		in  al, PS2_STATUS
		and al, PS2_STATUS_INPUT_BUFFER_FULL
		je  .end
		in  al, PS2_DATA
		jmp PS2_flush
	.end:
	ret


;handles figuring out which device's plugged in, and selects the driver depending on that
;void PS2_IRQ_update(uint64_t port_id)
func(global, PS2_IRQ_update)
	mov ax, [PS2_device_array + rdi * 2]
	cmp ax, 0xFFFF
	je  .end

	;mices
	cmp ax, 0x0000
	je  .mouse_support
	cmp ax, 0x0300
	je  .mouse_support
	cmp ax, 0x0400
	je  .mouse_support

	;keyboards
	cmp ax, 0xFFFE
	je  .KB_support
	cmp ax, 0xAB83
	je  .KB_support
	cmp ax, 0xABC1
	je  .KB_support
	cmp ax, 0xAB84
	je  .KB_support
	cmp ax, 0xAB85
	je  .KB_support
	cmp ax, 0xAB86
	je  .KB_support
	cmp ax, 0xAB90
	je  .KB_support
	cmp ax, 0xAB91
	je  .KB_support
	cmp ax, 0xAB92
	je  .KB_support
	cmp ax, 0xACA1
	je  .KB_support

	;unknown device
	jmp .end

	.mouse_support:
		;no drivers yet
		jmp .end
	.KB_support:
		;rdi already holds port ID
		call PS2KB_read

	.end:
	ret
