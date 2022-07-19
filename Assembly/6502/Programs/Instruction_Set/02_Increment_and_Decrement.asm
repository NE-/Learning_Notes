;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 14
; Purpose: Testing out the arithmetic group
;;

;; INC
; Increments contents of specified memory by one.
; Assembled as: 111 bb 110
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
INC $DF ; 111 00 110 1101 1111

;; INX
; Increments contents of Index Register X by one.
; Assembled as: 11101000
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
INX ; 11101000

;; INY
; Increments contents of Index Register Y by one.
; Assembled as: 11001000
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
INY ; 11001000

;; DEC
; Decrements contents of specified memory by one.
; Assembled as: 110 bb 110
;; ZP:         00 [2 Bytes 5 Cycles]
;; ZP,X:       10 [2 Bytes 6 Cycles]
;; Absolute:   01 [3 Bytes 6 Cycles]
;; Absolute,X: 11 [3 Bytes 7 Cycles]
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
DEC $FF02 ; 110 01 110 00000010 11111111

;; DEX
; Decrements contents of Index Register X by one.
; Assembled as: 11001010
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
DEX ; 11001010

;; DEY
; Decrements contents of Index Register Y by one.
; Assembled as: 10001000
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
DEY ; 10001000