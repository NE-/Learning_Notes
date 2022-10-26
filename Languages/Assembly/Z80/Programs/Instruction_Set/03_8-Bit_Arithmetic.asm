;;
; Author: NE- https://github.com/NE-
; Date: 2022 June 29
; Purpose: Testing out the 8-Bit Arithmetic Group
;;

;;;
; Machine Code Representation
; A -> 111
; B -> 000
; C -> 001
; D -> 010
; E -> 011
; H -> 100
; L -> 101
;;;

;; ADD A, r
; Contents of register r are added to contents of the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 10000 rrr
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADD A, C ; 10000 001

;; ADD A, n
; Integer n is added to contents of the Accumulator.
;; Result stored in the Accumulator.
; 2 Bytes, 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 11000110 nnnnnnnn
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADD A, 254 ; 11000110 11111110

;; ADD A, (HL)
; Contents of memory address specified by HL are added to contents of the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte, 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 10000110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADD A, (HL) ; 10000110

;; ADD A, (IX+d)
; Contents of memory address specified by IX + displacement d are added to contents of the Accumulator.
;; Result stored in the Accumulator.
; 3 Bytes, 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11011101 10000110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADD A, (IX+5) ; 11011101 10000110 00000101

;; ADD A, (IY+d)
; Contents of memory address specified by IY + displacement d are added to contents of the Accumulator.
;; Result stored in the Accumulator.
; 3 Bytes, 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11111101 10000110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADD A, (IY+5) ; 11111101 10000110 00000101

;; ADC A, s
; s (which can be r,n,(HL),(IX+d), or (IY+d)) along with the Carry Flag is added to the contents of the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if ADC A,r or ADC A,(HL) 
; 2 Bytes if ADC A, n
; 3 Bytes if ADC A,(IX+d) or ADC A,(IY+d)
; ADC A,r: 1 M Cycle, 4 T States, E.T 1.00μs
; ADC A,n or ADC A,(HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; ADC A,(IX+d) or ADC A,(IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
;; ADC A,r 10001 rrr
;; ADC A,n 11001110 nnnnnnnn
;; ADC A,(HL) 10001110
;; ADC A, (IX+d) 11011101 10001110 dddddddd
;; ADC A, (IY+d) 11111101 10001110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 7; otherwise reset
ADC A, (IX-82) ; 11011101 10001110 10101110

;; SUB s
; s (which can be r,n,(HL),(IX+d), or (IY+d)) is subtracted from contents of the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if SUB r or SUB (HL)
; 2 Bytes if SUB n
; 3 Bytes if SUB (IX+d) or SUB (IY+d)
; SUB r: 1 M Cycle, 4 T States, E.T 1.00μs
; SUB n or SUB (HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; SUB (IX+d) or SUB (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
;; SUB r 10010 rrr
;; SUB n 11010110 nnnnnnnn
;; SUB (HL) 10010110
;; SUB (IX+d) 11011101 10010110 dddddddd
;; SUB (IY+d) 11111101 10010110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if overflow; otherwise reset
; N - set
; C - set if borrow; otherwise reset
SUB D ; 100100 10

;; SBC A, s
; s (which can be r,n,(HL),(IX+d), or (IY+d)) along with Carry Flag is subtracted from contents of the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if SBC A, r or SBC A, (HL)
; 2 Bytes if SBC A, n
; 3 Bytes if SBC A, (IX+d) or SBC A, (IY+d)
; SBC A,r: 1 M Cycle, 4 T States, E.T 1.00μs
; SBC A,n SBC A,(HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; SBC A, (IX+d) or SBC A, (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
;; SBC A,r 10011 rrr
;; SBC A,n 110111110 nnnnnnnn
;; SBC A,(HL) 10011110
;; SBC A,(IX+d) 11011101 100111110 dddddddd
;; SBC A,(IY+d) 11111101 100111110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if overflow; otherwise reset
; N - set
; C - set if borrow; otherwise reset
SBC A, (HL) ; 10011110

;; AND s
; Logical AND is performed between s (which can be r,n,(HL),(IX+d), or (IY+d)) and the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if AND r or AND (HL)
; 2 Bytes if AND n
; 3 Bytes if AND (IX+d) or AND (IY+d)
; AND r: 1 M Cycle, 4 T States, E.T 1.00μs
; AND n or AND (HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; AND (IX+d) or AND (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
; AND r 10100 rrr
; AND n 11100110 nnnnnnnn
; AND (HL) 10100110
; AND (IX+d) 11011101 10100110 dddddddd
; AND (IY+d) 11111101 10100110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set
; P/V - set if overflow; otherwise reset
; N - Reset
; C - Reset
AND B ; 10100 000

;; OR s
; Logical OR is performed between s (which can be r,n,(HL),(IX+d), or (IY+d)) and the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if OR r or OR (HL)
; 2 Bytes if OR n
; 3 Bytes if OR (IX+d) or OR (IY+d)
; OR r: 1 M Cycle, 4 T States, E.T 1.00μs
; OR n or OR (HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; OR (IX+d) or OR (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
; OR r 10110 rrr
; OR n 11110110 nnnnnnnn
; OR (HL) 10110110
; OR (IX+d) 11011101 10110110 dddddddd
; OR (IY+d) 11111101 10110110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if overflow; otherwise reset
; N - Reset
; C - Reset
OR B ; 10110 000

;; XOR s
; Logical XOR is performed between s (which can be r,n,(HL),(IX+d), or (IY+d)) and the Accumulator.
;; Result stored in the Accumulator.
; 1 Byte if XOR r or XOR (HL)
; 2 Bytes if XOR n
; 3 Bytes if XOR (IX+d) or XOR (IY+d)
; XOR r: 1 M Cycle, 4 T States, E.T 1.00μs
; XOR n or XOR (HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; XOR (IX+d) or XOR (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
; XOR r 10101 rrr
; XOR n 11101110 nnnnnnnn
; XOR (HL) 10101110
; XOR (IX+d) 11011101 10101110 dddddddd
; XOR (IY+d) 11111101 10101110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - Reset
; C - Reset
XOR A ; 10101 111

;; CP s
; Contents of s (which can be r,n,(HL),(IX+d), or (IY+d)) are compared with Accumulator. If true compare, Z flag set
; 1 Byte if CP r or CP (HL)
; 2 Bytes if CP n
; 3 Bytes if CP (IX+d) or CP (IY+d)
; CP r: 1 M Cycle, 4 T States, E.T 1.00μs
; CP n or CP (HL): 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; CP (IX+d) or CP (IY+d): 5 M Cycle, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as:
; CP r 10111 rrr
; CP n 11111110 nnnnnnnn
; CP (HL) 10111110
; CP (IX+d) 11011101 10111110 dddddddd
; CP (IY+d) 11111101 10111110 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if overflow; otherwise reset
; N - set
; C - set if borrow; otherwise reset
CP L ; 10111 101

;; INC r
; Register r (A,B,C,D,E,H, or L) is incremented.
; 1 Byte, 1 M Cycle, 4 T States, E.T. 1.00μs
; Assembled as: 00 rrr 100
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if r was 7Fh before operation; otherwise reset
; N - Reset
INC H ; 00 100 100

;; INC HL
; Byte contained in address specified by contents of HL is incremented
; 1 Byte, 3 M Cycle, 11(4,4,3) T States, E.T. 2.75μs
; Assembled as: 00110100
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if (HL) was 7Fh before operation; otherwise reset
; N - Reset
INC HL ; 00110100

;; INC (IX+d)
; Contents of IX + displacemt d is incremented.
; 3 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T. 5.75μs
; Assembled as: 11011101 00110100 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if (IX+d) was 7Fh before operation; otherwise reset
; N - Reset
INC (IX-34) ; 11011101 00110100 11011110

;; INC (IY+d)
; Contents of IY + displacemt d is incremented.
; 3 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T. 5.75μs
; Assembled as: 11111101 00110100 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if carry from bit 3; otherwise reset
; P/V - set if (IY+d) was 7Fh before operation; otherwise reset
; N - Reset
INC (IY+8) ; 11111101 00110100 00001000

;; DEC m
; Contents of m (which can be r,(HL),(IX+d), or (IY+d)) are decremented.
; 1 Byte if DEC r or DEC (HL)
; 3 Bytes if DEC (IX+d) or DEC (IY+d)
; DEC r: 1 M Cycle, 4 T States, E.T 1.00μs
; DEC (HL): 3 M Cycle, 11(4,4,3) T States, E.T 2.75μs
; DEC (IX+d) or DEC (IY+d): 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
; DEC r 00 rrr 101
; DEC (HL) 00110101
; DEC (IX+d) 11011101 00110101 dddddddd
; DEC (IY+d) 11111101 00110101 dddddddd
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if m was 80h before operation; otherwise reset
; N - set
DEC L ; 00 101 101