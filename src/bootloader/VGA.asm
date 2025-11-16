bits 64



%define	VGA_AC_INDEX		0x3C0
%define	VGA_AC_WRITE		0x3C0
%define	VGA_AC_READ		0x3C1
%define	VGA_MISC_WRITE		0x3C2
%define VGA_SEQ_INDEX		0x3C4
%define VGA_SEQ_DATA		0x3C5
%define	VGA_DAC_READ_INDEX	0x3C7
%define	VGA_DAC_WRITE_INDEX	0x3C8
%define	VGA_DAC_DATA		0x3C9
%define	VGA_MISC_READ		0x3CC
%define VGA_GC_INDEX 		0x3CE
%define VGA_GC_DATA 		0x3CF
;/*			COLOR emulation		MONO emulation */
%define VGA_CRTC_INDEX		0x3D4		;/* 0x3B4 */
%define VGA_CRTC_DATA		0x3D5		;/* 0x3B5 */
%define	VGA_INSTAT_READ		0x3DA

%define	VGA_NUM_SEQ_REGS	5
%define	VGA_NUM_CRTC_REGS	25
%define	VGA_NUM_GC_REGS		9
%define	VGA_NUM_AC_REGS		21
%define	VGA_NUM_REGS		(1 + VGA_NUM_SEQ_REGS + VGA_NUM_CRTC_REGS + \
				VGA_NUM_GC_REGS + VGA_NUM_AC_REGS)

g_320x200x256:
    ;MISC
    db  0x63
    ;SEQ
    db  0x03, 0x01, 0x0F, 0x00, 0x0E
    ;CRTC
    db  0x5F, 0x4F, 0x50, 0x82, 0x54, 0x80, 0xBF, 0x1F, \
        0x00, 0x41, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
	    0x9C, 0x0E, 0x8F, 0x28,	0x40, 0x96, 0xB9, 0xA3, \
	    0xFF
    ;GC
    db  0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x05, 0x0F, \
    	0xFF
    ;AC
    db  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, \
	    0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, \
	    0x41, 0x00, 0x0F, 0x00,	0x00

%macro __outportb 2
    mov dx, %1
    mov al, %2
    out dx, al
%endmacro

%define outportb(port, data) __outportb port, data

%macro __inportb 1
    mov dx, %1
    in al, dx
%endmacro

%define inportb(port) __inportb port

%include "bootloader/VGA.inc"

;rdi: unsigned char* regs
write_regs:
	;unsigned i;

;/* write MISCELLANEOUS reg */
    outportb(VGA_MISC_WRITE, [rdi])
	inc rdi
;/* write SEQUENCER regs */
    mov rcx, VGA_NUM_SEQ_REGS
    mov r8, 0
.loop1:
    outportb(VGA_SEQ_INDEX, r8b);
	outportb(VGA_SEQ_DATA, [rdi]);
	inc rdi
    inc r8
    loop .loop1
;/* unlock CRTC registers */
    outportb(VGA_CRTC_INDEX, 0x03)
    inportb(VGA_CRTC_DATA)
    or al, 0x80
	outportb(VGA_CRTC_DATA, al)

	outportb(VGA_CRTC_INDEX, 0x11)
    inportb(VGA_CRTC_DATA) 
    and al, ~0x80
	outportb(VGA_CRTC_DATA, al)
;/* make sure they remain unlocked */
    mov al, [rdi + 0x03]
    or al, 0x80
    mov [rdi + 0x03], al

    mov al, [rdi + 0x11]
    and al, ~(0x80)
    mov [rdi + 0x11], al
;/* write CRTC regs */
    mov rcx, VGA_NUM_CRTC_REGS
    mov r8, 0
.loop2:
    outportb(VGA_CRTC_INDEX, r8b)
	outportb(VGA_CRTC_DATA, [rdi])
    inc rdi
    inc r8
    loop .loop2
;/* write GRAPHICS CONTROLLER regs */
    mov rcx, VGA_NUM_GC_REGS
    mov r8, 0
.loop3:
    outportb(VGA_GC_INDEX, r8b);
	outportb(VGA_GC_DATA, [rdi]);
    inc rdi
    inc r8
    loop .loop3
;/* write ATTRIBUTE CONTROLLER regs */
    mov rcx, VGA_NUM_AC_REGS
    mov r8, 0
.loop4:
    inportb(VGA_INSTAT_READ)
    outportb(VGA_AC_INDEX, r8b)
    outportb(VGA_AC_WRITE, [rdi])
    inc rdi
    inc r8
    loop .loop4
;/* lock 16-color palette and unblank display */
    inportb(VGA_INSTAT_READ)
	outportb(VGA_AC_INDEX, 0x20)
    ret

set_graphics_mode:
    mov rdi, g_320x200x256
	call write_regs

    ret