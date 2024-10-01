%ifndef STRING_INC
%define STRING_INC

%include "standard.inc"

; args : void* dest, u8 value, u64 n
; return : dest
extern memset

; args : void* dest, void* src, u64 n
; return : dest
extern memcpy

; args : void* dest, void* src, u64 n
; return : dest
extern memmove

; args : u8* str
; return : number of bytes before the first byte equal to '\0'
extern strlen

; args : u8* dest, u8* src
; return : dest
extern strcat

; args : u8* dest, u8* src, u64 n
; return : dest
extern strncat

; args : u8* dest, u8* src
; return : dest
extern strcpy

; args : s64 num, u8* buffer, u8 base
; return : If 'base' is less than 2 or greater than 36, NULL,
;          else if 'buffer' is NULL, a static string containing 'num' represented in base 'base',
;          else 'buffer' and buffer will contain the string representation of 'num' in base 'base'.
; notes : Future calls will modify the static string if 'buffer' isn't NULL but utoa calls won't.
extern itoa

; args : u64 num, u8* buffer, u8 base
; return : If 'base' is less than 2 or greater than 36, NULL,
;          else if 'buffer' is NULL, a static string containing 'num' represented in base 'base',
;          else 'buffer' and buffer will contain the string representation of 'num' in base 'base'.
; notes : Future calls will modify the static string if 'buffer' isn't NULL but itoa calls won't.
extern utoa

%endif ; STRING_INC
