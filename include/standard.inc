%ifndef STANDARD_INC
%define STANDARD_INC

%define true  1
%define false 0

%define NULL  0

%macro push_all 0
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
%endmacro

%macro pop_all 0
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
%endmacro

%endif ; STANDARD_INC
