;;
; Author: NE- https://github.com/NE-
; Date: 2022 June 28
; Purpose: Testing out the 8-Bit load group
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


;; LD r,r'
; Contents of register r' are loaded into r
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.0μs
; Assembled as: 01 rrr r'r'r'
LD A, B ; 01 111 000

;; LD r,n
; 8-bit integer n loaded to register r
; 2 Bytes, 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00 rrr 110 nnnnnnnn
LD C, 12 ; 00 001 110 00001100

;; LD r,(HL)
; 8-bit contents of memory location (HL) loaded to register r
; 1 Byte, 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 01 rrr 110
LD C, (HL) ; 01 001 110

;; LD r (IX+d)
; contents of memory location in IX+d (d is two's-compliment integer displacement) loaded into register r
; 3 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 2.50μs
; Assembled as: 11011101 01 rrr 110 dddddddd
LD B, (IX+3) ; 11011101 01 000 110 00000011

;; LD r, (IY+d)
; contents of memory location in IY+d (d is two's-compliment integer displacement) loaded into register r
; 3 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11111101 01 rrr 110 dddddddd
LD C, (IY+5) ; 11111101 01 001 110 00000101

;; LD (HL), r
; Contents of register r loaded into memory address specified by HL
; 1 Byte, 2 M Cycles, 7(4,3) T States, E.T 1.75μs
; Assembled as: 01110 rrr
LD (HL), A ; 01110 111

;; LD (IX+d), r
; Contents of register r loaded into memory address specified by IX+d
; 3 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11011101 01110 rrr dddddddd
LD (IX+20), L ; 11011101 01110 101 00010100

;; LD (IY+d), r
; Contents of register r loaded into memory address specified by IY+d
; 3 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11111101 01110 rrr dddddddd
LD (IY+32), H ; 11111101 01110 100 00100000

;; LD (HL), n
; Integer n loaded into memory address specified by HL
; 2 Bytes, 3 M Cycles, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 00110110 nnnnnnnn
LD (HL), 102 ; 00110110 01100110

;; LD (IX+d), n
; Integer n loaded into memory address specified by IX+d
; 4 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 4.75μs
; Assembled as: 11011101 00110110 dddddddd nnnnnnnn
LD (IX-3), -120 ; 11011101 00110110 11111101 10001000

;; LD (IY+d), n
; Integer n loaded into memory address specified by IY+d
; 4 Bytes, 5 M Cycles, 19(4,4,3,5,3) T States, E.T 2.50μs
; Assembled as: 11111101 00110110 dddddddd nnnnnnnn
LD (IY+8), 74 ; 11111101 00110110 00001000  01001010

;; LD A, (BC)
; Contents of memory address specified by BC loaded into Accumulator
; 1 Byte, 2 M Cycles, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00001010
LD A, (BC) ; 00001010

;; LD A, (DE)
; Contents of memory address specified by DE loaded into Accumulator
; 1 Byte, 2 M Cycles, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00011010
LD A, (DE) ; 00011010

;; LD A, (nn)
; Contents of memory address specified by nn loaded to Accumulator
; 3 Bytes, 4 M Cycles, 13(4,3,3,3) T States, E.T 3.25μs
; Assembled as: 00111010 nnnnnnnn nnnnnnnn (NOTE LITTLE ENDIAN)
LD A, (&B765) ; 00001010 01100101 (65h) 10110111 (B7h)

;; LD (BC), A
; Contents of Accumulator loaded into memory address specified by BC
; 1 Byte, 2 M Cycles, 7(4,3) T States, E.T. 1.75μs
; Assembled as: 00000010
LD (BC), A ; 00000010

;; LD (DE), A
; Contents of Accumulator loaded into memory address specified by DE
; 1 Byte, 2 M Cycles, 7(4,3) T States, E.T. 1.75μs
; Assembled as: 00010010
LD (DE), A ; 00010010

;; LD (nn), A
; Contents of Accumulator loaded into memory address specified by nn
; 3 Bytes, 4 M Cycles, 13(4,3,3,3) T States, E.T. 3.25μs
; Assembled as: 00110010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD (&1E9C), A ; 00000010 10011100 (9Ch) 00011110 (1Eh)

;; LD A, I
; Contents of Interrupt Vector I loaded to Accumulator
; 2 Bytes, 9(4,5) T States, E.T. 2.25μs
; Assembled as: 11101101 01010111
;;; Condition Bits Affected
; S - 1 if I is negative
; Z - 1 if I is 0
; H - Reset
; P/V - Contents of IFF2
; N - Reset
; If interrupt occurs during execution, Parity is 0
LD A, I ; 11101101 01010111

;; LD A, R
; Contents of Memory Refresh Register R loaded to Accumulator
; 2 Bytes, 9(4,5) T States, E.T. 2.25μs
; Assembled as: 11101101 01011111
;;; Condition Bits Affected
; S - 1 if R is negative
; Z - 1 if R is 0
; H - Reset
; P/V - Contents of IFF2
; N - Reset
; If interrupt occurs during execution, Parity is 0
LD A, R ; 11101101 01011111

;; LD I, A
; Contents of Accumulator loaded to Interupt Control Vector Register I
; 2 Bytes, 9(4,5) T States, E.T. 2.25μs
; Assembled as: 11101101 01000111
LD I, A ; 11101101 01000111

;; LD R, A
; Contents of Accumulator loaded to Memory Refresh Register R
; 2 Bytes, 9(4,5) T States, E.T. 2.25μs
; Assembled as: 11101101 01001111
LD R, A ; 11101101 01001111
