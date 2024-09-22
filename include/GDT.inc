%ifndef GDT_INC
%define GDT_INC

%include "boot.inc"
%include "standard.inc"

%define GDT_DESCRIPTOR_PRIVILEGE_KERNEL     0
%define GDT_DESCRIPTOR_PRIVILEGE_KERNEL_LOW 1
%define GDT_DESCRIPTOR_PRIVILEGE_USER_HIGH  2
%define GDT_DESCRIPTOR_PRIVILEGE_USER       3

%define GDT_ACCESS_BYTE(p, dpl, s, e, dc, rw, a)	((((p) & 1) << 7)  | \
													(((dpl) & 3) << 5) | \
													(((s) & 1) << 4)   | \
													(((e) & 1) << 3)   | \
													(((dc) & 1) << 2)  | \
													(((rw) & 1) << 1)  | \
													(((a) & 1) << 0))
%define ARCADOS_ACCESS_BYTE(s, e, dc, rw, a) \
				GDT_ACCESS_BYTE(true, GDT_DESCRIPTOR_PRIVILEGE_KERNEL, s, e, dc, rw, a)

%define GDT_FLAG(g, size, l)	(((g & 1) << 3)   | \
								((size & 1) << 2) | \
								((l & 1) << 1))

%define GDT_ENTRY(base, limit, access, flag)	(((limit) & 0xFFFF)         | \
												(((base) & 0xFFFFFF) << 16) | \
												(((access) & 0xFF) << 40)   | \
												(((limit) & 0xF0000) << 32) | \
												(((flag) & 0xF) << 52)      | \
												(((base) & 0xFF000000) << 32))

%define GDT_LIMIT_BYTE_TO_GRANULAR(limit)		((limit >> 12) + ((limit & 0xFFFFFF) > 0))

%endif ; GDT_INC
