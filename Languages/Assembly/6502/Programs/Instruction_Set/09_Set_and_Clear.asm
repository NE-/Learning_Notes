;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 19
; Purpose: Testing out the Set and Clear group
;;

;; CLC
; Clears the Carry flag.
; Assembled as: 00011000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; C - Reset
CLC

;; SEC
; Sets the Carry flag.
; Assembled as: 00111000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; C - Set
SEC

;; CLD
; Clears the Decimal Mode flag.
; Assembled as: 11011000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; D - Reset
CLD

;; SED
; Sets the Decimal Mode flag.
; Assembled as: 11111000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; D - Set
SED

;; CLI
; Clears the Interrupt Disable flag.
; Assembled as: 01011000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; I - Reset
CLI

;; SEI
; Sets the Interrupt Disable flag.
; Assembled as: 01111000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; I - Set
SEI

;; CLV
; Clears the Overflow flag.
; Assembled as: 10111000
; 1 Byte 2 Cycles
;;; Condition Bits Affected
; V - Reset
CLV
