;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 03
; Purpose: Testing out the Call and Return Group
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

;; CALL nn
; Current contents of PC pushed onto top of the stack then nn loaded to PC.
;; At the end of the subroutine, RET can be used to return to the original program flow by popping top of stack to PC.
;;; Because this is a 3-Byte instruction, PC incremented by 3 before the push is executed.
; 3 Bytes, 5 M Cycle, 17(4,3,4,3,3) T States, E.T 4.25μs
; Assembled as: 11001101 nnnnnnnn (low-order) nnnnnnnn (high-order)
CALL $FF00 ; 11001101 00000000 11111111

;; CALL cc, nn
; If cc is true, current contents of PC pushed onto top of the stack then nn loaded to PC.
;; At the end of the subroutine, RET can be used to return to the original program flow by popping top of stack to PC.
; If cc is false, PC incremented as usual and program continues to next sequential instruction.
;;; Because this is a 3-Byte instruction, PC incremented by 3 before the push is executed.
; 3 Bytes, 
; If cc == true: 5 M Cycle, 17(4,3,4,3,3) T States, E.T 4.25μs
; Else: 3 M Cycle, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 11 ccc 100 nnnnnnnn (low-order) nnnnnnnn (high-order)
CALL P, $FA12 ; 11110100 00010010 11111010

;; RET
; The byte at memory location specified by contents of SP moved to low-order 8-bits of PC.
; SP is now incremented and the byte at the memory location specified by the new contents of this instruction is fetched from memory location specified by PC.
;; Normally used to return program flow after a CALL.
; 1 Byte, 3 M Cycle, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 11001001
RET ; 11001001

;; RET cc
; If cc is true, the byte at memory location specified by contents of SP moved to low-order 8-bits of PC.
; SP is incremented and the byte at the memory location specified by the new contents of SP are moved to high-order 8-bits of PC.
; SP is incremented again
;; Normally used to return program flow after a CALL.
; If cc is false, PC incremented as usual and program continues with the next sequential instruction.
; 1 Byte, 
; If cc == true: 3 M Cycle, 11(5,3,3) T States, E.T 2.75μs
; Else: 1 M Cycle, 5 T States, E.T 1.25μs
; Assembled as: 11 ccc 000
RET PE ; 11 101 000

;; RETI
; Used at the end of a maskable interrupt service routine to:
;; Restore contents of PC
;; Signal I/O device that the interrupt routine is completed.
;;; RETI also facilitates nesting of interrupts, allows higher priority devices to temporarily suspend service of lower priority service routines.
;;;; Does not enable interrupts that were disabled when the interrupt routine was entered.
;; Before doint RETI, Enable Interrupt (EI) instruction should be executed to allow recognition of interrupts after completion of current service routine.
; 2 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11101101 01001101
RETI ; 11101101 01001101

;; RETN
; Used at end of nonmaskable interrupts service routine to restore contents of PC.
; State of IFF2 copied back to IFF1 to immediately enable maskable interrupts following RETN.
; 2 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11101101 01000101
RETN ; 11101101 01000101

;; RST p
; Current PC contents pushed onto stack, and page 0 memory location assigned by p loaded to PC.
;;;
; Machine Code Representation of p
; 00h -> 000
; 08h -> 001
; 10h -> 010
; 18h -> 011
; 20h -> 100
; 28h -> 101
; 30h -> 110
; 38h -> 111
;;;
; 1 Byte, 3 M Cycle, 11(5,3,3) T States, E.T 2.75μs
; Assembled as: 11 ppp 111
RST &28 ; 11 101 111