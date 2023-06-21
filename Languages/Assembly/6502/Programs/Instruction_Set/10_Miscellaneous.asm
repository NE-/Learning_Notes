;;
; Author:  NE- https://github.com/NE-
; Date:    2022 July 19
; Purpose: Testing out the Miscellaneous group
;;

;; BRK
; Force an Interrupt.
;; PC incremented by 2 and Break status set, then P and PC pushed onto stack.
;; Top of stack PC high byte, after low byte PC, 3rd P register with B = 1.
; Assembled as: 00000000
; 1 Byte 7 Cycles
;;; Condition Bits Affected
; I - Set
BRK

;; NOP
; No Operation.
;; Can be used to:
;;; Give label to object program byte
;;; Fine tune a delay (2 Cycles per NOP)
;;; Replace instruction bytes through self-modifying code
;;; Replace instructions in debugging phase such as jumps
;; Mostly used in debugging and testing
; Assembled as: 11101010
; 1 Byte 2 Cycles
NOP
