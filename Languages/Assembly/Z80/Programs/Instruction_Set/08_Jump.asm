;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 02
; Purpose: Testing out the Jump Group
;;

;;;
; Machine Code Representation   Flag
; NZ (Non-Zero)     -> 000       Z
; Z (Zero)          -> 001       Z
; NC (No Carry)     -> 010       C
; C (Carry)         -> 011       C
; PO (Parity Odd)   -> 100      P/V
; PE (Parity Even)  -> 101      P/V
; P (Sign Positive) -> 110       S
; M (Sign Negative) -> 111       S
;;;

;; JP nn
; nn is loaded to Program Counter. 
;; The next instruction is fetched from location designated by the new contents of Program Counter.
; 3 Bytes, 3 M Cycle, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 11000011 nnnnnnnn (low-order byte) nnnnnnnn (high-order byte)
JP &FF00 ; 11000011 00000000 11111111

;; JP cc, nn
; If condition cc (NZ Z NC C PO PE P M) is true, nn loaded into PC, and program continues with instruction beginning at address nn.
; If condition cc (NZ Z NC C PO PE P M) is false, PC incremented as usual
; 3 Bytes, 3 M Cycle, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 11 ccc 010 nnnnnnnn (low-order byte) nnnnnnnn (high-order byte)
JP C, &00FF ; 11 011 010 11111111 00000000

;; JR e
; Unconditional branching with displacement e.
;; e is added to the PC and the next instruction is fetched from location designated by the new contents of Program Counter.
;; e ranged from -126 to +129. Assembler automatically adjusts for twice incremented PC.
; 2 Bytes, 3 M Cycle, 12(4,3,5) T States, E.T 3.00μs
; Assembled as: 00011000 eeeeeeee (e-2)
JR 2 ; 00011000 00000000

;; JR C, e
; Conditional branching depending on result of a test on Carry flag.
;; If flag == 1, displacement e is added to PC.
;; If flag == 0, the next instruction executed is taken from location following this instruction
; 2 Bytes,
; If condition met: 3 M Cycle, 12(4,3,5) T States, E.T 3.00μs
; Else: 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00111000 eeeeeeee (e-2)
JR C, $-4 ; 00111000 11111010 

;; JR NC, e
; Conditional branching depending on result of a test on Carry flag.
;; If flag == 0, displacement e is added to PC.
;; If flag == 1, the next instruction executed is taken from location following this instruction
; 2 Bytes,
; If condition met: 3 M Cycle, 12(4,3,5) T States, E.T 3.00μs
; Else: 7 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00110000 eeeeeeee (e-2)
JR NC, $-4 ; 00110000 11111010 

;; JR Z, e
; Conditional branching depending on result of a test on Zero flag.
;; If flag == 1, displacement e is added to PC.
;; If flag == 0, the next instruction executed is taken from location following this instruction
; 2 Bytes,
; If condition met: 3 M Cycle, 12(4,3,5) T States, E.T 3.00μs
; Else: 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00101000 eeeeeeee (e-2)
JR Z, $+54 ; 00101000 00110100

;; JR NZ, e
; Conditional branching depending on result of a test on Zero flag.
;; If flag == 0, displacement e is added to PC.
;; If flag == 1, the next instruction executed is taken from location following this instruction
; 2 Bytes,
; If condition met: 3 M Cycle, 12(4,3,5) T States, E.T 3.00μs
; Else: 2 M Cycle, 7(4,3) T States, E.T 1.75μs
; Assembled as: 00100000 eeeeeeee (e-2)
JR NZ, $+54 ; 00100000 00110100

;; JP (HL)
; PC loaded with contents of (HL) 
;; The next instruction is fetched from location designated by the new contents of Program Counter.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 11101001
JP (HL); 11101001

;; JP (IX)
; PC loaded with contents of (IX) 
;; The next instruction is fetched from location designated by the new contents of Program Counter.
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11011101 11101001
JP (IX); 11011101 11101001

;; JP (IY)
; PC loaded with contents of (IY) 
;; The next instruction is fetched from location designated by the new contents of Program Counter.
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11111101 11101001
JP (IY); 11111101 11101001

;; DJNZ, e
; Similar to conditional jumps except a register value detremines branching.
;; B decremented, if nonzero value remains, displacement e is added to PC, else next instruction following this instruction is executed.
; 2 Bytes, 
; If b != 0: 3 M Cycle, 13(5,3,5) T States, E.T 3.25μs
; Else: 2 M Cycle, 8(5,3) T States, E.T 2.00μs
; Assembled as: 00010000 eeeeeeee (e-2)
DJNZ MYLOOP ; 00010000 <varies>