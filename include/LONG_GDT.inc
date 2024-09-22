%ifndef LONG_GDT_INC
%define LONG_GDT_INC

%include "GDT.inc"

%define LONG_GDT_ENTRY(base, limit, access, flag)	(((limit) & 0xFFFF)					| \
												(((base) & 0xFFFFFF) << 16)				| \
												(((access) & 0xFF) << 40)				| \
												(((limit) & 0xF0000) << 32)				| \
												(((flag) & 0xF) << 52)      			| \
												(((base) & 0xFF000000) << 32)) 			| \
												(((base) & 0xFFFFFFFF00000000) << 32)	| \

%endif ; LONG_GDT_INC
