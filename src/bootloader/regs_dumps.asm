%include "bootloader/regs_dumps.inc"
%include "LuLib/lutypes.inc"

%define CONVERT_BUFFER_LEN (128)

section .text

flag_reg_name:
static  flag_reg_name: data
    db "FLGS"

flag_reg_bank:
static flag_reg_bank: data
    dd 0

segment_regs_names:
static segment_regs_names: data
    .cs: db " CS "
    .ds: db " DS "
    .ss: db " SS "
    .es: db " ES "
    .fs: db " FS "
    .gs: db " GS "

segment_regs_banks:
static segment_regs_banks: data
    .cs: dw 0
    .ds: dw 0
    .ss: dw 0
    .es: dw 0
    .fs: dw 0
    .gs: dw 0

control_regs_names:
static control_regs_names: data
    .cr0: db "CR0 "
    .cr2: db "CR2 "
    .cr3: db "CR3 "
    .cr4: db "CR4 "
    .cr8: db "CR8 "

control_regs_banks:
static control_regs_banks: data
    .cr0: dq 0
    .cr2: dq 0
    .cr3: dq 0
    .cr4: dq 0
    .cr8: dq 0

table_regs_names:
static table_regs_names: data
    .gdtr: db "GDTR"
    .idtr: db "IDTR"

gdtr_reg_bank:
static gdtr_reg_bank: data
    .limit: dw 0
    .base:  dq 0

idtr_reg_bank:
static idtr_reg_bank: data
    .limit: dw 0
    .base:  dq 0

ap_regs_names_32:
static ap_regs_names_32: data
    .eip: db "EIP "
    .eax: db "EAX "
    .ebx: db "EBX "
    .ecx: db "ECX "
    .edx: db "EDX "
    .esi: db "ESI "
    .edi: db "EDI "
    .esp: db "ESP "
    .ebp: db "EBP "

ap_regs_names_64:
static ap_regs_names_64: data
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

ap_regs_banks:
static ap_regs_banks: data
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

error_code_bank:
static error_code_bank: data
    dq 0

convert_buffer:
static convert_buffer: data
    times CONVERT_BUFFER_LEN db 0

convert_digits:
static convert_digits: data
    db "0123456789ABCDEF"

;
; const char* convert_bin_32(uint32_t n);
; const char* convert_hex_32(uint32_t n);
; void save_regs_32(void);
;
; const char* convert_bin_64(uint64_t n);
; const char* convert_hex_64(uint64_t n);
; void save_regs_64(void);
;
