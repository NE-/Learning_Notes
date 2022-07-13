;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 13
; Purpose: Testing out the load and store group
;;

;; LDA
; Loads contents of selected memory byte into Accumulator.
; Compiled as: 101 aaa 01 
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 5* Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
LDA $12,X ; 101 101 01 00010010

;; LDX
; Load contents of selected memory byte into X.
; Compiled as: 101 ddd 10
;; Immediate:  000 [2 Bytes 2 Cycles]
;; ZP:         001 [2 Bytes 3 Cycles]
;; ZP,Y:       101 [2 Bytes 4 Cycles]
;; Absolute:   011 [3 Bytes 4 Cycles]
;; Absolute,Y: 111 [3 Bytes 4* Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
LDX $6754,Y ; 101 111 10 01010100 01100111

;; LDY
; Load contents of selected memory byte into Y.
; Compiled as: 101 ddd 00
;; Immediate:  000 [2 Bytes 2 Cycles]
;; ZP:         001 [2 Bytes 3 Cycles]
;; ZP,X:       101 [2 Bytes 4 Cycles]
;; Absolute:   011 [3 Bytes 4 Cycles]
;; Absolute,X: 111 [3 Bytes 4* Cycles]
;; * Add 1 if page boundary crossed
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
LDY $A6CD ; 101 011 00 11001101 10100110

;; STA
; Store contents of Accumulator into specified memory location.
; Compiled as: 100 aaa 01
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 5 Cycles]
;; Absolute,Y:   110 [3 Bytes 5 Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 6 Cycles]
STA ($20,X) ; 10000001 00100000

;; STX
; Store contents of Index register X into specified memory location.
; Compiled as: 100 bb 110
;; ZP:       00 [2 Bytes 3 Cycles]
;; ZP,Y:     10 [2 Bytes 4 Cycles]
;; Absolute: 01 [3 Bytes 4 Cycles]
STX $DF ; 100 00 110 11011111


;; STY
; Store contents of Index register Y into specified memory location.
; Compiled as: 100 bb 100
;; ZP:       00 [2 Bytes 3 Cycles]
;; ZP,X:     10 [2 Bytes 4 Cycles]
;; Absolute: 01 [3 Bytes 4 Cycles]
STY $DF,X ; 100 10 100 11011111
