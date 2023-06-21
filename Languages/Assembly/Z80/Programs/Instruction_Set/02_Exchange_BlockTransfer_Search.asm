;;
; Author:  NE- https://github.com/NE-
; Date:    2022 June 29
; Purpose: Testing out the Exchange, Block Transfer, and Search Group
;;

;; EX DE, HL
; 2-byte contents of DE and HL are exchanged
; 1 Byte, 1 M Cycle, 4 T States, E.T. 1.00μs
; Assembled as: 11101011
EX DE, HL ; 11101011

;; EX AF, AF'
; 2-byte contents of AF and AF' are exchanged
; 1 Byte, 1 M Cycle, 4 T States, E.T. 1.00μs
; Assembled as: 00001000
EX AF, AF' ; 00001000 '

;; EXX
; BC DE HL are exchanged with BC' DE' HL' respectively
; 1 Byte, 1 M Cycle, 4 T States, E.T. 1.00μs
; Assembled as: 11011001
EXX ; 11011001

;; EX (SP), HL
; Low-order byte in HL exchanged with contents of memory address specified by SP and high-order of HL exchanged with (SP+1).
; 1 Byte, 5 M Cycle, 19(4,3,4,3,5) T States, E.T. 4.75μs
; Assembled as: 11100011
EX (SP), HL ; 11100011

;; EX (SP), IX
; Low-order byte in IX exchanged with contents of memory address specified by SP and high-order of IX exchanged with (SP+1).
; 2 Bytes, 6 M Cycle, 23(4,4,3,4,3,5) T States, E.T. 5.75μs
; Assembled as: 11011101 11100011
EX (SP), IX ; 11011101 11100011

;; EX (SP), IY
; Low-order byte in IY exchanged with contents of memory address specified by SP and high-order of IY exchanged with (SP+1).
; 2 Bytes, 6 M Cycle, 23(4,4,3,4,3,5) T States, E.T. 5.75μs
; Assembled as: 11111101 11100011
EX (SP), IY ; 11111101 11100011

;; LDI
; 1 byte of data transferred from memory location held by HL to memory address held by DE.
;; Then both HL and DE incremented and the Byte Counter BC pair is decremented
; 2 Bytes, 4 M Cycle, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10100000
;;; Condition Bits Affected
; H - Reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - Reset
LDI ; 11101101 10100000

;; LDIR
; 1 byte of data transferred from memory location held by HL to memory address held by DE.
;; Then both HL and DE incremented and the Byte Counter BC pair is decremented
;; If decrement allowed BC to go to 0, then the instruction is terminated.
;; Else the Program Counter PC is decremented by 2 and the instruction is repeated.
;;; Interrupts are recognized and 2 refresh cycles are executed after each data transfer.
;;; When BC is set to 0 prior to execution, the instruction loops through 64KB
; 2 Bytes, 
;; BC != 0: 5 M Cycle, 21(4,4,3,5,5) T States, E.T. 5.25μs
;; BC == 0: 4 M Cycle, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10110000
;;; Condition Bits Affected
; H - Reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - Reset
LDIR ; 11101101 10110000

;; LDD
; 1 byte of data transferred from memory location held by HL to memory address held by DE.
;; Then both HL and DE decremented and the Byte Counter BC pair is decremented
; 2 Bytes, 4 M Cycle, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10101000
;;; Condition Bits Affected
; H - Reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - Reset
LDD ; 11101101 10101000

;; LDDR
; 1 byte of data transferred from memory location held by HL to memory address held by DE.
;; Then both HL and DE decremented and the Byte Counter BC pair is decremented
;; If decrementing causes BC to go to 0, then instruction terminated
;; Else PC is decremented by 2 and instruction repeated.
;;; Interrupts are recognized and 2 refresh cycles are executed after each data transfer.
; 2 Bytes, 
;; BC != 0: 5 M Cycle, 21(4,4,3,5,5) T States, E.T. 5.25μs
;; BC == 0: 4 M Cycle, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10111000
;;; Condition Bits Affected
; H - Reset
; P/V - Reset
; N - Reset
LDDR ; 11101101 10111000

;; CPI
; Contents in memory location specified by HL is compared with the contents of the Accumulator.
;; With a true compare, a condition bit is set, then HL is incremented and BC is decremented
; 2 Bytes, 4 M Cycles, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10100001
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if A == (HL); otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - set
CPI ; 11101101 10100001

;; CPIR
; Contents in memory location specified by HL is compared with the contents of the Accumulator.
;; During a compare, a condition bit is set, HL is incremented and BC is decremented.
;; If decrementing causes BC to go to 0 or if A = (HL), instruction is terminated.
;; Else if BC != 0 and A != (HL), PC is decremented by 2 and instruction repeated.
;;; Interrupts are recognized and 2 refresh cycles are executed after each data transfer.
; 2 Bytes, 
; For BC != 0 and A != (HL): 5 M Cycles, 21(4,4,3,5,5) T States, E.T. 5.25μs
; For BC == 0 and A == (HL): 4 M Cycles, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10110001
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if A == (HL); otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - set
CPIR ; 111101101 10110001


;; CPD
; Contents in memory location specified by HL is compared with the contents of the Accumulator.
;; During a compare, a condition bit is set, HL is decremented and BC is decremented.
; 2 Bytes, 4 M Cycles, 16(4,4,3,5) T States, E.T. 4.00μs
; Assembled as: 11101101 10101001
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if A == (HL); otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - set
CPD ; 11101101 10101001


;; CPDR
; Contents in memory location specified by HL is compared with the contents of the Accumulator.
;; During a compare, a condition bit is set, HL is decremented and BC is decremented.
;; If decrementing allows BC to go to 0 or if A == (HL), instruction is terminated
;; Else if BC != 0 and A == (HL) then PC decremented by 2 and instruction repeated.
;;; Interrupts are recognized and 2 refresh cycles are executed after each data transfer.
;;; When BC set to 0, prior to instruction execution, the instruction loops through 64KB if no match is found.
; 2 Bytes, 
; For BC != 0 and A != (HL): 5 M Cycles, 21(4,4,3,5,5) T States, E.T. 5.25μs
; Assembled as: 11101101 10111001
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if A == (HL); otherwise reset
; H - set if borrow from bit 4; otherwise reset
; P/V - set if BC - 1 != 0; otherwise reset
; N - set
CPDR ; 11101101 10111001