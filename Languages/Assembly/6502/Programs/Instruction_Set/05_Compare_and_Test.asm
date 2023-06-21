;;
; Author:  NE- https://github.com/NE-
; Date:    2022 July 16
; Purpose: Testing out the Compare and Test group
;;

;;;
; Condition         N Z C
; Register < Memory 1 0 0
; Register = Memory 0 1 1
; Register > Memory 0 0 1
;;;

;; CMP
; Compare contents of specified memory address with Accumulator.
;; Subtracts memory contents with Accumulator and sets flags accordingly.
; Assembled as: 110 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 5* Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected (Table Above)
CMP ($FF23,X) ; 110 000 01 00100011

;; CPX
; Compare contents of specified memory address with Index Register X.
; Assembled as: 1110 cc 00
;; Immediate: 00 [2 Bytes 2 Cycles]
;; ZP:        01 [2 Bytes 3 Cycles]
;; Absolute:  11 [3 Bytes 4 Cycles]
;;; Condition Bits Affected (Table Above)
CPX $02 ; 1110 01 00 00000010

;; CPY
; Compare contents of specified memory address with Index Register Y.
; Assembled as: 1100 cc 00
;; Immediate: 00 [2 Bytes 2 Cycles]
;; ZP:        01 [2 Bytes 3 Cycles]
;; Absolute:  11 [3 Bytes 4 Cycles]
;;; Condition Bits Affected (Table Above)
CPY #45 ; 1100 00 00 00101101

;; BIT
; Logically AND Accumulator with contents of selected memory location.
; Assembled as: 0010 x 100
;; Absolute: 1 [2 Bytes 3 Cycles]
;; ZP:       0 [3 Bytes 4 Cycles]
;;; Condition Bits Affected
; N - Matches bit 7 of contents in tested address.
; Z - Set if AND results in 0; otherwise reset.
; V - Matches bit 7 of contents in tested address.
BIT $3E02 ; 0010 1 100 00000010 00111110
