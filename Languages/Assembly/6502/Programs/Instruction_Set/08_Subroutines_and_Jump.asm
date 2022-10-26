;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 19
; Purpose: Testing out the Subroutine and Jump group
;;

;; JMP
; Jump to new location by changing value of Program Counter.
; ⚠️🪲 When used with absolute indirect, a hardware bug can result in unexpected behavior when specified address is $xxFF.
;; Example: $11FF will read low byte from $11FF and high byte from $1100 instead of from $1200.
;; Due to overflow in lower byte not being carried into upper byte.
; Assembled as: 01 y 01100
;; Absolute: 0 [3 Bytes 3 Cycles]
;; Indirect: 1 [3 Bytes 5 Cycles]
JMP MyLoop ; 01001100 <varies>

;; JSR
; Jump to new location saving return address.
;; Address before next instruction (PC-1) pushed onto stack: first upper byte followed by lower.
;; PC then set to target address.
; Assembled as: 00100000
; 3 Bytes 6 Cycles
JSR MyLoop ; 00100000 <varies>

;; RTS
; Return from subroutine (where it called with JSR).
;; PC altered with value from the top off the stack.
; Assembled as: 01100000
; 1 Byte 6 Cycles
RTS ; 01100000

;; RTI
; Return from an interrupt.
;; Pull Status Register (P) and PC off the stack. P is on top, low byte of PC is after, high byte of PC 3rd.
; Assembled as: 01000000
; 1 Byte 6 Cycles
RTI ; 01000000
