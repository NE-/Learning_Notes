;;
; Author:  NE- https://github.com/NE-
; Date:    2022 July 19
; Purpose: Testing out the Transfer group
;;

;; TAX
; Move contents of Accumulator to Index Register X.
; Assembled as: 10101010
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TAX

;; TXA
; Move contents of Index Register X to Accumulator.
; Assembled as: 10001010
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TXA

;; TAY
; Move contents of Accumulator to Index Register Y.
; Assembled as: 10101000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TAY

;; TYA
; Move contents of Index Register Y to Accumulator.
; Assembled as: 10011000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TYA

;; TSX
; Transfer Stack Pointer to Index Register X.
; Assembled as: 10111010
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TSX

;; TXS
; Transfer Index Register X to Stack Pointer.
; Assembled as: 10111010
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
TXS

;; PHA
; Push Accumulator onto stack.
; Assembled as: 01001000
; 1 Byte 3 Cycles
PHA

;; PLA
; Pull a byte from stack to the accumulator.
; Assembled as: 01101000
; 1 Byte 3 Cycles
;;; Condition Bits Affected
; N - Set if negative; otherwise reset.
; Z - Set if 0; otherwise reset.
PLA

;; PHP
; Push Processor Status Register (P) onto stack.
; Assembled as: 00001000
; 1 Byte 3 Cycles
PHP

;; PLP
; Pull a byte from stack to Status Register P and status flags are updated accordingly.
; Assembled as: 00101000
; 1 Byte 4 Cycles
;;; Condition Bits Affected
; ALL - depending on value pulled.
PLP
