;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 02
; Purpose: Testing out the Bit Set, Reset, and Test Group
;;

;;;
; Machine Code Representation
; B -> 000
; C -> 001
; D -> 010
; E -> 011
; H -> 100
; L -> 101
; A -> 111
;
; Bit Tested
; 0 -> 000
; 1 -> 001
; 2 -> 010
; 3 -> 011
; 4 -> 100
; 5 -> 101
; 6 -> 110
; 7 -> 111
;;;

;; BIT b, r
; Tests bit b in register r and sets the Z flag accordingly.
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 4.50μs
; Assembled as: 11001011 01 bbb rrr
;;; Condition Bits Affected
; S - unknown
; Z - set if specified bit is 0; otherwise reset
; H - set
; P/V - unknown
; N - reset
BIT 4, L ; 11001011 01 100 101

;; BIT b, (HL)
; Tests bit b in memory location specified by contents of (HL) and sets the Z flag accordingly.
; 2 Bytes, 3 M Cycle, 12(4,4,4) T States, E.T 3.00μs
; Assembled as: 11001011 01 bbb 110
;;; Condition Bits Affected
; S - unknown
; Z - set if specified bit is 0; otherwise reset
; H - set
; P/V - unknown
; N - reset
BIT 3, (HL) ; 11001011 01 011 110

;; BIT b, (IX+d)
; Tests bit b in memory location specified by contents of (IX+d) and sets the Z flag accordingly.
; 4 Bytes, 5 M Cycle, 20(4,4,3,5,4) T States, E.T 5.00μs
; Assembled as: 11011101 11001011 dddddddd 01 bbb 110
;;; Condition Bits Affected
; S - unknown
; Z - set if specified bit is 0; otherwise reset
; H - set
; P/V - unknown
; N - reset
BIT 6, (IX-34) ; 11011101 11001011 11011110 01 110 110

;; BIT b, (IY+d)
; Tests bit b in memory location specified by contents of (IY+d) and sets the Z flag accordingly.
; 4 Bytes, 5 M Cycle, 20(4,4,3,5,4) T States, E.T 5.00μs
; Assembled as: 11111101 11001011 dddddddd 01 bbb 110
;;; Condition Bits Affected
; S - unknown
; Z - set if specified bit is 0; otherwise reset
; H - set
; P/V - unknown
; N - reset
BIT 2, (IY+104) ; 11111101 11001011 01101000 01 010 110

;; SET b, r
; Bit b in register r is set.
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11001011 11 bbb rrr
SET 5, A ; 11001011 11 101 111

;; SET b, (HL)
; Bit b in memory location addressed by the contents of HL is set.
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11001011 11 bbb 110
SET 0, (HL) ; 11001011 11 000 110

;; SET b, (IX+d)
; Bit b in memory location addressed by the contents of (IX+d) is set.
; 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as: 11011101 11001011 dddddddd 11 bbb 110
SET 4, (IX+3) ; 11011101 11001011 00000011 11 100 110

;; SET b, (IY+d)
; Bit b in memory location addressed by the contents of (IY+d) is set.
; 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as: 11111101 11001011 dddddddd 11 bbb 110
SET 6, (IY-33) ; 11111101 11001011 11011111 11 110 110

;; RES b, m
; Bit b in operand m (any of r (HL) (IX+d) (IY+d)) is reset.
; RES b,m: 2 Bytes, 4 M Cycle, 8(4,4) T States, E.T 2.00μs 
; RES (HL) 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; RES b, (IX+d) or RES b, (IY+d) 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; RES b,m: 11001011 10 bbb rrr
;; RES b,(HL): 11001011 10 bbb 110
;; RES b,(IX+d): 110111101 11001011 dddddddd 10 bbb 110
;; RES b,(IY+d): 111111101 11001011 dddddddd 10 bbb 110
RES 6, D ; 11001011 10 110 010