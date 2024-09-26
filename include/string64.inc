%ifndef STRING_64_INC
%define STRING_64_INC

; args : u64 dest, u64 src, u64 n
extern memcpy64

; args : u64 dest, u8 value, u64 n
extern memset64

%endif ; STRING_64_INC
