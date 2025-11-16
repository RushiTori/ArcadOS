%ifndef RTC_TIMER_INC
%define RTC_TIMER_INC

%include "LuLib/lutypes.inc"

; RTCTime formal definition
struc RTCTime
	; Time in seconds
	; int32_t sec;
	struc_member(int32_t, sec, 1)

	; Time in nanoseconds
	; int32_t nsec;
	struc_member(int32_t, nsec, 1)
endstruc

; RTCTime as a lutype
	define_type(RTCTime, q, qword)

;
; Real Time Clock Precision
; NOTE: Used by rtc_print() function to control the output's precision
;
; enum RTCPrecision: uint8_t
	reset_enum_value(0)

	; Nanoseconds
	add_enum(RTC_NANOS)

	; Equivalent to RTC_NANOS
	add_enum_value(RTC_PRECISION_MIN, RTC_NANOS)

	; Microseconds
	add_enum(RTC_MICROS)

	; Milliseconds
	add_enum(RTC_MILLIS)

	; Seconds
	add_enum(RTC_SECONDS)

	; Minutes
	add_enum(RTC_MINUTES)

	; Hours
	add_enum(RTC_HOURS)

	; Days
	add_enum(RTC_DAYS)

	; Equivalent to RTC_DAYS
	add_enum_value(RTC_PRECISION_MAX, RTC_DAYS)

; void init_rtc(void);
;
; Assumes the insterupts are disabled
extern init_rtc

; RTCTime rtc_get_time(void);
;
; Return: The time since init_rtc().
extern rtc_get_time

; uint64_t rtc_get_ticks(void);
;
; Return: The number of rtc_ticks since init_rtc().
; Note: A rtc_tick is roughly 122 microseconds.
extern rtc_get_ticks

; RTCTime rtc_time_diff(RTCTime lhs, RTCTime rhs);
;
; Return: lhs - rhs.
extern rtc_time_diff

; void rtc_sleep(RTCTime time);
;
; Will sleep for at least time, if time is too small or not exactly in line with the ticks, it'll sleep for an extra tick.
extern rtc_sleep

; void rtc_sleep_ticks(uint64_t ticks);
;
; Like rtc_sleep but with rtc_tick precision.
; Note: A rtc_tick is roughly 122 microseconds.
extern rtc_sleep_ticks

; int64_t rtc_snprint(RTCTime time, char* buffer, uint64_t n);
;
; Equivalent to rtc_snprint_ex(time, buffer, n, RTC_PRECISION_MIN, RTC_PRECISION_MAX);
extern rtc_snprint

; int64_t rtc_snprint_ex(RTCTime time, char* buffer, uint64_t n, RTCPrecision min, RTCPrecision max);
;
; Like your usual snprintf(...), will write up-to n-1 characters to buffer and will take care of the nul terminator.
; Return: strlen(buffer) on success, and any negative value on falure.
extern rtc_snprint_ex

%endif ; RTC_TIMER_INC
