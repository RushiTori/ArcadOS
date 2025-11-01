%ifndef LUTYPES_INC
%define LUTYPES_INC

%include "lutypes_utils.inc"

define_type(int8,    b, byte)
define_type(int16,   w, word)
define_type(int32,   d, dword)
define_type(int64,   q, qword)
define_type(int128,  o, oword)

define_type(uint8,   b, byte)
define_type(uint16,  w, word)
define_type(uint32,  d, dword)
define_type(uint64,  q, qword)
define_type(uint128, o, oword)

define_type(pointer, q, qword)
%define NULL 0

define_type(bool, b, byte)
%define true  1
%define false 0

%endif ; LUTYPES_INC
