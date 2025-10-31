%ifndef IDT_INC
%define IDT_INC

struc IDTDescriptor
	.byteSize: resw 1
	.ptr: resq 1
endstruc

struc IDTGateDescriptor
	.offset_0: resw 1
	.seg_sel: resw 1
	.IST: resb 1
	.gate_type_dpl: resb 1
	.offset_1: resw 1
	.offset_2: resd 1
	.reserved: resd 1
endstruc

%define IDTR_START	0x06000
%define IDT_START	0x06010

%define GATE_TYPE_TASK 0x5
%define GATE_TYPE_ISR_16 0x6
%define GATE_TYPE_TRAP_16 0x7
%define GATE_TYPE_ISR_32 0xE
%define GATE_TYPE_TRAP_32 0xF
%define GATE_TYPE_ISR_64 0xE
%define GATE_TYPE_TRAP_64 0xF

%define LGATE_DESCRIPTOR_FLAGS(p, dpl, type, ist) ((p) << 15) \
											    | ((dpl) << 13) \
												| ((type) << 8) \
												| (ist)

%define LGATE_DESCRIPTOR_LO(offset, segment, p, ist, type, dpl) ((offset) & 0xFFFF) \
														| (((segment) & 0xFFFF) << 16) \
														| (LGATE_DESCRIPTOR_FLAGS(p, dpl, type, ist) << 32)

%define LGATE_DESCRIPTOR_HI(offset) (((offset) & 0xFFFFFFFFFFFF0000) >> 16)

%macro DEFINE_LGATE_DESCRIPTOR 5
	dq LGATE_DESCRIPTOR_LO(%1, %2, %3, %4, %5)
	dq LGATE_DESCRIPTOR_HI(%1)
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
