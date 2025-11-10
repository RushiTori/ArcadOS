%include "engine/PS2.inc"
%include "engine/display.inc"
%include "engine/timer.inc"

section .data

error_init_controller_error:
	db "PS/2 error: controller self test", 0xA, "failed!", 0

error_port1_check:
	db "PS/2 error: port 1 test failed!", 0
error_port2_check:
	db "PS/2 error: port 2 test failed!", 0

error_port1_id_reception:
	db "PS/2 error: could not obtain", 0xA, "port 1 device id!", 0
error_port2_id_reception:
	db "PS/2 error: could not obtain", 0xA, "port 2 device id!", 0

error_disable_scan_port1:
	db "PS/2 error: could not disable", 0xA, "scanning on port 1!", 0
error_disable_scan_port2:
	db "PS/2 error: could not disable", 0xA, "scanning on port 2!", 0

error_enable_scan_port1:
	db "PS/2 error: could not enable", 0xA, "scanning on port 1!", 0
error_enable_scan_port2:
	db "PS/2 error: could not enable", 0xA, "scanning on port 2!", 0

error_port_not_populated_maybe_port1:
	db "PS/2 error: no ID fetch on port 1!", 0
error_port_not_populated_maybe_port2:
	db "PS/2 error: no ID fetch on port 2!", 0

warning_no_PS2_devices:
	db "no PS/2 devices were detected", 0xA, "by the driver!", 0xA, "the OS will proceed in", 0xA, "5 seconds.", 0

section .bss

PS2_Port_2:
	resb 1   ;true

PS2_Port_1_state:
	resb 1   ;success
PS2_Port_2_state:
	resb 1   ;successs

PS2_Port_1_Device:
	resw 1   ;MF2 keyboard
PS2_Port_2_Device:
	resw 1   ;mouse

PS2_TimeoutTimer:
	resq 1

section .text

initPS2:
global initPS2:function
	;skipping step 1 and step 2, too lazy to rewrite ACPI stuff

	;step 3
    ;disable devices

    ;call waitForSending
    mov al, PS2_COMMAND_DISABLE_PORT1
    out PS2_COMMAND, al

    ;call waitForSending
    mov al, PS2_COMMAND_DISABLE_PORT2
    out PS2_COMMAND, al

    ;call waitForSending
	;step 4
    call flushBuffer

	;step 5
    mov al, PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al 
    ;call waitForSending

	call waitForResponse
    in al, PS2_DATA     

	and al, ~(PS2_CONFIGURATION_PORT1_INTERRUPT | PS2_CONFIGURATION_PORT1_CLOCK | PS2_CONFIGURATION_PORT1_TRANSLATE)
	mov ah, al

	mov al, PS2_COMMAND_WRITE_CONFIG_BYTE
	out PS2_COMMAND, al
	;call waitForSending

	mov al, ah
	out PS2_DATA, al
	call waitForSending ;send back new flags

	;now do step 6
	mov al, PS2_COMMAND_TEST_CONTROLLER
	out PS2_COMMAND, al

	call waitForResponse
	in al, PS2_DATA
	cmp al, PS2_CONTROLLER_TEST_SUCCESSFUL
	jne .error_controller_test

	;step 7
	mov al, PS2_COMMAND_ENABLE_PORT2
	out PS2_COMMAND, al

	mov al, PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al

	call waitForResponse
	in al, PS2_DATA
	and al, PS2_CONFIGURATION_PORT2_CLOCK
	jz .dualPort
		mov byte [PS2_Port_2], false
		jmp .endPortCheck
	.dualPort:
		mov byte [PS2_Port_2], true
	.endPortCheck:

	;step 8
	mov al, PS2_COMMAND_TEST_PORT1
	out PS2_COMMAND, al
	call waitForResponse
	in al, PS2_DATA
	mov byte [PS2_Port_1_state], al
	cmp al, PORT_STATE_SUCCESS
	jne .error_port1_failed
	cmp byte [PS2_Port_2], true
	jne .skipPort2Test

		mov al, PS2_COMMAND_TEST_PORT2
		out PS2_COMMAND, al
		call waitForResponse
		in al, PS2_DATA
		mov byte [PS2_Port_2_state], al
		cmp al, PORT_STATE_SUCCESS
		jne .error_port2_failed
	.skipPort2Test:

	;step 9
	mov al, PS2_COMMAND_ENABLE_PORT1
	out PS2_COMMAND, al

	mov al, PS2_COMMAND_READ_CONFIG_BYTE
	out PS2_COMMAND, al

	call waitForResponse
	in al, PS2_DATA
	or al, PS2_CONFIGURATION_PORT1_INTERRUPT
	mov ah, al

	cmp byte [PS2_Port_2], true
	jne .skipPort2Enable
		mov al, PS2_COMMAND_ENABLE_PORT2
		out PS2_COMMAND, al

		or ah, PS2_CONFIGURATION_PORT2_INTERRUPT
	.skipPort2Enable:
	mov al, PS2_COMMAND_WRITE_CONFIG_BYTE
	out PS2_COMMAND, al

	mov al, ah
	out PS2_DATA, al
	call waitForSending

	;step 10
	mov al, PS2_DEVICE_COMMAND_RESET
	out PS2_DATA, al 
	call waitForSending

	call waitForResponse
	cmp rax, -1
	je .noIDPort1
	in al, PS2_DATA

	cmp al, 0xFA
	je .checkAA_Port1

	cmp al, 0xAA
	je .checkFA_Port1

	cmp al, 0xFC
	je .error_port1_id

	;port not populated
	mov ax, 0xFFFF
	mov [PS2_Port_1_Device], ax
	jmp .endGetDeviceIDPort1

	.checkAA_Port1:
		call waitForResponse
		cmp rax, -1
		je .noIDPort1
		in al, PS2_DATA

		cmp al, 0xAA
		jne .error_port1_id
		jmp .getDeviceIDPort1
	.checkFA_Port1:
		call waitForResponse
		in al, PS2_DATA

		cmp al, 0xFA
		jne .error_port1_id
		jmp .getDeviceIDPort1
	.getDeviceIDPort1:
		call waitForResponse
		in al, PS2_DATA
		
		mov ah, al
		xor al, al
		push rax
		call waitForResponse
		cmp rax, -1
		pop rax
		je .writeDataPort1

		in al, PS2_DATA
	.writeDataPort1:
		mov [PS2_Port_1_Device], ax
		jmp .endGetDeviceIDPort1
	.nothingPort1:
		mov ax, 0xFFFF
		mov [PS2_Port_1_Device], ax
		jmp .endGetDeviceIDPort1
	.noIDPort1:
		mov ax, 0xFFFE
		mov [PS2_Port_1_Device], ax
	.endGetDeviceIDPort1:

	mov al, [PS2_Port_2]
	cmp al, true
	jne .endGetDeviceIDPort2

	mov al, PS2_COMMAND_WRITE_BYTE_PORT2
	out PS2_COMMAND, al
	mov al, PS2_DEVICE_COMMAND_RESET
	out PS2_DATA, al
	call waitForSending

	call waitForResponse
	cmp rax, -1
	je .nothingPort2
	in al, PS2_DATA

	cmp al, 0xFA
	je .checkAA_Port2

	cmp al, 0xAA
	je .checkFA_Port2

	cmp al, 0xFC
	je .error_port2_id

	;port not populated
	mov ax, 0xFFFF
	mov [PS2_Port_2_Device], ax
	jmp .endGetDeviceIDPort2

	.checkAA_Port2:
		call waitForResponse
		cmp rax, -1
		je .noIDPort2
		in al, PS2_DATA

		cmp al, 0xAA
		jne .error_port2_id
		jmp .getDeviceIDPort2
	.checkFA_Port2:
		call waitForResponse
		in al, PS2_DATA

		cmp al, 0xFA
		jne .error_port2_id
		jmp .getDeviceIDPort2
	.getDeviceIDPort2:
		call waitForResponse
		in al, PS2_DATA
		
		mov ah, al
		xor al, al
		push rax
		call waitForResponse
		cmp rax, -1
		pop rax
		je .writeDataPort2

		in al, PS2_DATA
	.writeDataPort2:
		mov [PS2_Port_2_Device], ax
		jmp .endGetDeviceIDPort2
	.nothingPort2:
		mov ax, 0xFFFF
		mov [PS2_Port_2_Device], ax
		jmp .endGetDeviceIDPort2
	.noIDPort2:
		mov ax, 0xFFFE
		mov [PS2_Port_2_Device], ax
	.endGetDeviceIDPort2:
	call GetDevicesID

	;mov al, PS2_COMMAND_READ_CONFIG_BYTE
	;out PS2_COMMAND, al

	;call waitForResponse

	;mov cl, al
	;mov al, PS2_COMMAND_WRITE_CONFIG_BYTE
	;out PS2_COMMAND, al

	;call waitForResponse

	;mov al, cl
	;out PS2_DATA, al

	ret
.error_controller_test:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_init_controller_error
	call draw_text
	jmp $

.error_port1_failed:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port1_check
	call draw_text
	jmp $

.error_port2_failed:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port2_check
	call draw_text
	jmp $

.error_port1_id:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port1_id_reception
	call draw_text
	jmp $

.error_port2_id:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port2_id_reception
	call draw_text
	jmp $

GetDevicesID:	
	mov dil, PS2_DEVICE_COMMAND_DISABLE_SCAN
	call PS2SendCommandToPort1
	cmp rax, -1
	je .port1NotPopulated

	mov dil, PS2_DEVICE_COMMAND_IDENTIFY
	call PS2SendCommandToPort1
	cmp rax, -1
	je .error_port_prolly_not_populated_port1

	call waitForResponse
	cmp rax, -1
	je .nocodePort1

	in al, PS2_DATA
	xor ah, ah
	push rax
	call waitForResponse
	cmp rax, -1
	pop rax
	je .endcodePort1
	mov ah, al
	in al, PS2_DATA
	jmp .endcodePort1
.nocodePort1:
	mov ax, 0xFFFE
	jmp .endcodePort1
.port1NotPopulated:
	mov ax, 0xFFFF
	mov word [PS2_Port_1_Device], ax
	jmp .tryPort2
.endcodePort1:
	mov word [PS2_Port_1_Device], ax

	mov dil, PS2_DEVICE_COMMAND_ENABLE_SCAN
	call PS2SendCommandToPort1

.tryPort2:
	mov dil, PS2_DEVICE_COMMAND_DISABLE_SCAN
	call PS2SendCommandToPort2
	cmp rax, -1
	je .port2NotPopulated

	mov dil, PS2_DEVICE_COMMAND_IDENTIFY
	call PS2SendCommandToPort2
	cmp rax, -1
	je .error_port_prolly_not_populated_port2

	call waitForResponse
	cmp rax, -1
	je .nocodePort2

	in al, PS2_DATA
	xor ah, ah
	push rax
	call waitForResponse
	cmp rax, -1
	pop rax
	je .endcodePort2
	mov ah, al
	in al, PS2_DATA
	jmp .endcodePort2
.nocodePort2:
	mov ax, 0xFFFE
	jmp .endcodePort2
.port2NotPopulated:
	mov ax, 0xFFFF
	mov word [PS2_Port_2_Device], ax
	jmp .end
.endcodePort2:
	mov word [PS2_Port_2_Device], ax

	mov dil, PS2_DEVICE_COMMAND_ENABLE_SCAN
	call PS2SendCommandToPort2
.end:

	mov ax, [PS2_Port_1_Device]
	mov bx, [PS2_Port_2_Device]

	cmp ax, bx
	jne .end_check

	cmp ax, 0xFFFF
	jne .end_check

	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, warning_no_PS2_devices
	call draw_text

	mov rdi, 5000 ;5 seconds
	shl rdi, 32
	call sleep_ms
.end_check:

	ret

.error_disable_scan_port1:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_disable_scan_port1
	call draw_text
	jmp $
.error_disable_scan_port2:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_disable_scan_port2
	call draw_text
	jmp $
.error_enable_scan_port1:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_enable_scan_port1
	call draw_text
	jmp $
.error_enable_scan_port2:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_enable_scan_port2
	call draw_text
	jmp $
.error_port_prolly_not_populated_port1:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port_not_populated_maybe_port1
	call draw_text
	jmp $
.error_port_prolly_not_populated_port2:
	mov rdi, 0x1
	call set_color

	call clear_screen

	mov rdi, 0
	mov rsi, 0
	mov rdx, error_port_not_populated_maybe_port1
	call draw_text
	jmp $

PS2SendCommandToPort1:
	xor rcx, rcx
.resend:
	mov al, dil
	out PS2_DATA, al
	call waitForSending
	call waitForResponse
	cmp rax, -1
	je .timeout

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

.timeout:
	mov rax, -1
.end:
	ret
.error:
	jmp $

PS2SendCommandToPort2:
	xor rcx, rcx
.resend:
	mov al, PS2_COMMAND_WRITE_BYTE_PORT2
	out PS2_COMMAND, al
	mov al, dil
	out PS2_DATA, al
	call waitForSending
	call waitForResponse
	cmp rax, -1
	je .timeout

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
	
.timeout:
	mov rax, -1
.end:
	ret
.error:
	jmp $

waitForResponse:
static waitForResponse:function
	call create_timer
	cmp rax, -1
	je .error
	mov qword [PS2_TimeoutTimer], rax
.loop:
	mov rdi, qword [PS2_TimeoutTimer]
	call get_timer_ms
	shr rax, 32
	cmp rax, 5
	jge .timeout

	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	jz .loop

	mov rax, 0
	jmp .end

.timeout:
	mov rax, -1
.end:
	push rax
	mov rdi, qword [PS2_TimeoutTimer]
	call remove_timer
	pop rax
	ret
.error:
	jmp $ ;timer creation failed

waitForSending:
static waitForSending:function
	call create_timer
	cmp rax, -1
	je .error
	mov qword [PS2_TimeoutTimer], rax
.loop:
	mov rdi, qword [PS2_TimeoutTimer]
	call get_timer_ms
	shr rax, 32
	cmp rax, 5
	jge .timeout

	in al, PS2_STATUS
	and al, PS2_STATUS_OUTPUT_BUFFER_FULL
	jnz .loop
	mov rax, 0
	jmp .end
.timeout:
	mov rdi, qword [PS2_TimeoutTimer]
	call remove_timer
	mov rax, -1
.end:
	ret
.error:
	jmp $ ;timer creation failed

flushBuffer:
static flushBuffer:function
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	je .end
	in al, PS2_DATA
	jmp flushBuffer
	.end:
	ret

;handles figuring out which device's plugged in, and selects the driver depending on that
;rdi: port ID
updatePS2IRQ:
	ret