;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 16
; Purpose: Testing out the shift and rotate group
;;

;; ASL
; Arithemtic left shift of contents of Accumulator or memory address.
;; '0' is shifted into bit 0 and bit 7 shifted into carry.
; Assembled as: 000 bb 110
;; Accumulator: 00001010 [1 Byte 2 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
; C - Holds value of shifted bit 7.
ASL $45,X ; 000 10 110 01000101

;; LSR
; Logical right shift of Accumulator or memory address.
;; '0' is shifted into bit 7 and bit 0 shifted into carry.
; Assembled as: 010 bb 110
;; Accumulator: 01001010 [1 Byte 2 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;;; Condition Bits Affected
; N - Always set (bit 7 always 0).
; Z - Set if zero result; otherwise reset.
; C - Holds value of shifted bit 0.
LSR $653F ; 010 01 110 00111111 01100101

;; ROL
; Rotate left shift of contents of Accumulator or memory address.
;; Carry shifted to bit 0 and bit 7 shifted into carry.
; Assembled as: 001 bb 110
;; Accumulator: 00101010 [1 Byte 2 Cycles]
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
; C - Holds value of shifted bit 7.
ROL A ; 00101010

;; ROR
; Rotate right shift of contents of Accumulator or memory address.
;; Carry shifted to bit 7 and bit 0 shifted into carry.
; Assembled as: 011 bb 110
;; Accumulator: 01101010 [1 Byte 2 Cycles]
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
; C - Holds value of shifted bit 7.
ROR $F00F,X ; 011 01 110 00001111 11110000
