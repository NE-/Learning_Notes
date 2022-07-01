;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 01
; Purpose: Testing out the  Rotate and Shift Groups
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
;;;

;; RCLA
; Contents of Accumulator rotated left 1 bit position. Bit 7 copied into Carry flag and also to bit 0.
;; Bit 0 is the least-significant bit.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00000111
;;; Condition Bits Affected
; H - reset
; N - reset
; C - holds data from bit 7 of Accumulator
RCLA ; 00000111

;; RLA
; Contents of Accumulator rotated left 1 bit position through the Carry flag.
;; Previous contents of Carry flag copied to bit 0.
;; Bit 0 is the least-significant bit.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00010111
;;; Condition Bits Affected
; H - reset
; N - reset
; C - holds data from bit 7 of Accumulator
RLA ; 00010111

;; RRCA
; Contents of Accumulator rotated right 1 bit position. Bit 0 copied into Carry flag and also to bit 7.
;; Bit 0 is the least-significant bit.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00001111
;;; Condition Bits Affected
; H - reset
; N - reset
; C - holds data from bit 0 of Accumulator
RRCA ; 00001111

;; RRA
; Contents of Accumulator rotated right 1 bit position through the Carry flag. 
;; Previous contents of Carry flag copied to bit 7.
;; Bit 0 is the least-significant bit.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00011111
;;; Condition Bits Affected
; H - reset
; N - reset
; C - holds data from bit 0 of Accumulator
RRCA ; 00001111

;; RLC r
; Contents of register r rotated left 1 bit position. Bit 7 copied to Carry flag and also to bit 0
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11001011 00000 rrr
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
RLC D ; 11001011 00000 010

;; RLC (HL)
; Contents of memory address specified by HL are rotated left 1 bit position. Bit 7 copied to Carry flag and also to bit 0.
;; Bit 0 is the least-significant bit.
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11001011 00000110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
RLC (HL) ; 11001011 00000110

;; RLC (IX+d)
; Contents of memory address specified by IX + displacement d are rotated left 1 bit position. Bit 7 copied to Carry flag and also to bit 0.
;; Bit 0 is the least-significant bit.
; 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as: 11011101 11001011 dddddddd 00000110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
RLC (IX+56) ; 11011101 11001011 00111000 00000110

;; RLC (IY+d)
; Contents of memory address specified by IY + displacement d are rotated left 1 bit position. Bit 7 copied to Carry flag and also to bit 0.
;; Bit 0 is the least-significant bit.
; 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as: 11011101 11001011 dddddddd 00000110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
RLC (IY-74) ; 11111101 11001011 10110110 00000110

;; RL m
; Contents of m (any r or (HL) (IX+d) (IY+d)) rotated left 1 bit position. Bit 7 copied to Carry flag and the previous contents of the Carry flag copied to bit 0.
; RL r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; RL (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; RL (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; RL r: 11001011 00010 rrr
;; RL (HL): 11001011 00010110
;; RL (IX+d): 11011101 11001011 dddddddd 00010110
;; RL (IY+d): 11111101 11001011 dddddddd 00010110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
RL D ; 11001011 00010 010

;; RRC m
; Contents of m (any r or (HL) (IX+d) (IY+d)) rotated right 1 bit position. Bit 0 copied to Carry flag and to bit 7.
;; Bit 0 is the least-significant bit.
; RRC r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; RRC (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; RRC (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; RRC r: 11001011 00001 rrr
;; RRC (HL): 11001011 00001110
;; RRC (IX+d): 11011101 11001011 dddddddd 00001110
;; RRC (IY+d): 11111101 11001011 dddddddd 00001110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 0 of source register
RRC E ; 11001011 00001 011

;; RR m
; Contents of m (any r or (HL) (IX+d) (IY+d)) rotated right 1 bit position through the Carry flag. Bit 0 copied to Carry flag and the previous contents of the Carry flag copied to bit 7.
;; Bit 0 is the least-significant bit.
; RR r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; RR (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; RR (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; RR r: 11001011 00001 rrr
;; RR (HL): 11001011 00011110
;; RR (IX+d): 11011101 11001011 dddddddd 00011110
;; RR (IY+d): 11111101 11001011 dddddddd 00011110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 0 of source register
RR (HL) ; 11001011 00011110

;; SLA m
; Arithmetic shift left 1 bit position is performed on the contents of m (any r or (HL) (IX+d) (IY+d)). Contents of bit 7 copied to the Carry flag.
;; Bit 0 is the least-significant bit.
; SLA r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; SLA (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; SLA (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; SLA r: 11001011 00100 rrr
;; SLA (HL): 11001011 00100110
;; SLA (IX+d): 11011101 11001011 dddddddd 00100110
;; SLA (IY+d): 11111101 11001011 dddddddd 00100110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 7 of source register
SLA (IX+38) ; 11011101 11001011 00100110 00100110

;; SRA m
; Arithmetic shift right 1 bit position is performed on the contents of m (any r or (HL) (IX+d) (IY+d)). 
;; Contents of bit 0 copied to the Carry flag and previous contents of bit 7 remain unchanged.
;; Bit 0 is the least-significant bit.
; SRA r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; SRA (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; SRA (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; SRA r: 11001011 00101 rrr
;; SRA (HL): 11001011 00101110
;; SRA (IX+d): 11011101 11001011 dddddddd 00101110
;; SRA (IY+d): 11111101 11001011 dddddddd 00101110
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 0 of source register
SRA L ; 11001011 00101 101

;; SRL m
; Contents of m (any r or (HL) (IX+d) (IY+d)) shifted right by 1 bit position. 
;; Contents of bit 0 copied to the Carry flag and bit 7 is reset.
;; Bit 0 is the least-significant bit.
; SRL r: 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; SRL (HL): 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; SRL (IX+d) or RL(IY+d): 4 Bytes, 6 M Cycle, 23(4,4,3,5,4,3) T States, E.T 5.75μs
; Assembled as:
;; SRL r: 11001011 00111 rrr
;; SRL (HL): 11001011 00111110
;; SRL (IX+d): 11011101 11001011 dddddddd 00111110
;; SRL (IY+d): 11111101 11001011 dddddddd 00111110
;;; Condition Bits Affected
; S - reset
; Z - set if result is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
; C - holds data from bit 0 of source register
SRL (HL) ; 11001011 00111110

;; RLD
; Contents of low-order 4 bits of memory location (HL) copied to high-order 4 bits of that same memory location.
;; Previous contents of high-order 4 bits copied to low-order 4 bits of Accumulator
;; Previous contents of low-order 4 bits of Accumulator copied to low-order 4 bits of memory location (HL).
;; Contents of high-order bits of Accumulator are unaffected.
; 2 Bytes, 5 M Cycle, 18(4,4,3,4,3) T States, E.T 4.50μs
; Assembled as: 11101101 01101111
;;; Condition Bits Affected
; S - set if Accumulator is negative after an operation; otherwise reset.
; Z - set if Accumulator is 0 after an operation; otherwise reset.
; H - reset
; P/V - set if parity of Accumulator is even after an operation; otherwise reset.
; N - reset
RLD ; 11101101 01101111

;; RRD
; Contents of low-order 4 bits of memory location (HL) copied to low-order 4 bits of Accumulator
;; Previous contents of low-order 4 bits of Accumulator copied to high-order 4 bits of (HL)
;; Previous contents of high-order 4 bits of (HL) copied to low-order 4 bits of memory location (HL).
;; Contents of high-order bits of Accumulator are unaffected.
; 2 Bytes, 5 M Cycle, 18(4,4,3,4,3) T States, E.T 4.50μs
; Assembled as: 11101101 01100111
;;; Condition Bits Affected
; S - set if Accumulator is negative after an operation; otherwise reset.
; Z - set if Accumulator is 0 after an operation; otherwise reset.
; H - reset
; P/V - set if parity of Accumulator is even after an operation; otherwise reset.
; N - reset
RLD ; 11101101 01101111