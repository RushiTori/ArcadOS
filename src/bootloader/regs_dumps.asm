%include "bootloader/regs_dumps.inc"
%include "LuLib/lutypes.inc"

%define CONVERT_BUFFER_LEN (128)

section .text

regs_names_32:
static  regs_names_32: data
    .eip: db "EIP "
    .eax: db "EAX "
    .ebx: db "EBX "
    .ecx: db "ECX "
    .edx: db "EDX "
    .esi: db "ESI "
    .edi: db "EDI "
    .esp: db "ESP "
    .ebp: db "EBP "
    .cs:  db " CS "
    .ds:  db " DS "
    .ss:  db " SS "
    .es:  db " ES "
    .fs:  db " FS "
    .gs:  db " GS "

regs_names_64:
static regs_names_64: data
    .rip: db "RIP "
    .rax: db "RAX "
    .rbx: db "RBX "
    .rcx: db "RCX "
    .rdx: db "RDX "
    .rsi: db "RSI "
    .rdi: db "RDI "
    .rsp: db "RSP "
    .rbp: db "RBP "
    .r8:  db " R8 "
    .r9:  db " R9 "
    .r10: db "R10 "
    .r11: db "R11 "
    .r12: db "R12 "
    .r13: db "R13 "
    .r14: db "R14 "
    .r15: db "R15 "

regs_banks:
static regs_banks: data
    .eip:
    .rip: dq 0
    .eax:
    .rax: dq 0
    .ebx:
    .rbx: dq 0
    .ecx:
    .rcx: dq 0
    .edx:
    .rdx: dq 0
    .esi:
    .rsi: dq 0
    .edi:
    .rdi: dq 0
    .esp:
    .rsp: dq 0
    .ebp:
    .rbp: dq 0
    .r8:  dq 0
    .r9:  dq 0
    .r12: dq 0
    .r13: dq 0
    .r14: dq 0
    .r15: dq 0
    .cs:  dq 0
    .ds:  dq 0
    .ss:  dq 0
    .es:  dq 0
    .fs:  dq 0
    .gs:  dq 0

convert_buffer:
static convert_buffer: data
    times CONVERT_BUFFER_LEN db 0
