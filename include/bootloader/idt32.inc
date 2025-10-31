%ifndef IDT_INC
%define IDT_INC

struc IDTDescriptor32
	.byteSize: resw 1
	.ptr: resd 1
endstruc

struc IDTGateDescriptor32
	.offset_0: resw 1
	.seg_sel: resw 1
    .reserved: resb 1
	.gate_type_dpl: resb 1
	.offset_1: resw 1
endstruc

%define IDTR_START	0x040000
%define IDT_START	0x04000A

%define GATE_P 0x8000

%define GATE_TYPE_TASK 0x5
%define GATE_TYPE_ISR_16 0x6
%define GATE_TYPE_TRAP_16 0x7
%define GATE_TYPE_ISR_32 0xE
%define GATE_TYPE_TRAP_32 0xF

%define LGATE_DESCRIPTOR_LO32(offset, segment, type, dpl) ((offset) & 0xFFFF) \
														| (((segment) & 0xFFFF) << 16) \
														| (((type) & 0xF) << 40) \
														| (((dpl) & 0x3) << 45) \
														| (1 << 47) \

%define LGATE_DESCRIPTOR_HI32(offset) ((((offset) & 0xFFFFFFFFFFFF0000) << 48) >> 16)

%macro DEFINE_LGATE_DESCRIPTOR32 5
	dq LGATE_DESCRIPTOR_LO32(%1, %2, %3, %4, %5)
	dq LGATE_DESCRIPTOR_HI32(%1)
%endmacro

%define TRAP_DIVBYZERO				0x00
%define TRAP_DEBUG					0x01
%define TRAP_NMI					0x02
%define TRAP_BRKP					0x03
%define TRAP_OVF					0x04
%define TRAP_BOUNDRANGE				0x05
%define TRAP_INVALOP				0x06
%define TRAP_DEVICENOTAVAIL			0x07
%define TRAP_DOUBLEFAULT			0x08
%define TRAP_INVALIDTSS				0x0A
%define TRAP_SEGNOTPRES				0x0B
%define TRAP_STACKSEGFAULT			0x0C
%define TRAP_GPF					0x0D
%define TRAP_PAGEFAULT				0x0E
%define TRAP_X87FPE					0x10
%define TRAP_ALIGNCHECK				0x11
%define TRAP_MACHINECHECK			0x12
%define TRAP_SIMDFPE				0x13
%define TRAP_VIRTEXCEPT				0x14
%define TRAP_CONTROLPROTEXCEPT		0x15
%define TRAP_HYPERVISORINJECTION	0x1C
%define TRAP_VMMCOMMEXCEPT			0x1D
%define TRAP_SECUREXCEPT			0x1E

%endif ;IDT_INC
