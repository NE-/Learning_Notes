;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 16
; Purpose: Testing out the logic group
;;

;; AND
; Perform bitwise AND to the Accumulator.
; Compiled as: 001 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 5 Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
AND $56A3,X ; 001 111 01 10100011 1010110

;; ORA
; Perform logical OR to the Accumulator.
; Compiled as: 000 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 5 Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
ORA #23 ; 000 010 01

;; EOR
; Perform Exclusive-OR to the Accumulator.
; Compiled as: 010 aaa 01
;; Immediate:    010 [2 Bytes 2 Cycles]
;; ZP:           001 [2 Bytes 3 Cycles]
;; ZP,X:         101 [2 Bytes 4 Cycles]
;; Absolute:     011 [3 Bytes 4 Cycles]
;; Absolute,X:   111 [3 Bytes 4* Cycles]
;; Absolute,Y:   110 [3 Bytes 4* Cycles]
;; (Indirect,X): 000 [2 Bytes 6 Cycles]
;; (Indirect),Y: 100 [2 Bytes 5 Cycles]
;; * Add 1 if page boundary crossed
;;; Condition Bits Affected
; N - Set if bit 7 is 1; otherwise reset.
; Z - Set if result was 0; otherwise reset.
EOR ($45),Y ; 010 100 01 01000101