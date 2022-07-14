;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 14
; Purpose: Testing out the arithmetic group
;;

;; ADC
; Add contents of specified memory address, with carry, to Accumulator.
; Compiled as: 011 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (indirect),Y: 100 [2 Bytes 5* Cycles]
;; * Add 1 if page boundary is crossed.
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
; C - Set if carry occured; otherwise reset.
; V - Set if overflow occured; otherwise reset.
ADC ($45), Y ; 011 100 01 01000101

;; SBC
; Subtract contents of specified memory address, with compliment carry, to Accumulator.
; Compiled as: 111 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (indirect),Y: 100 [2 Bytes 5* Cycles]
;; * Add 1 if page boundary is crossed.
;;; Condition Bits Affected
; N - Set if result was negative; otherwise reset.
; Z - Set if zero result; otherwise reset.
; C - Set if carry occured; otherwise reset.
; V - Set if overflow occured; otherwise reset.
SBC $0D0F ; 111 011 01 00001111 00001101