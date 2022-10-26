;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 01
; Purpose: Testing out the General-Purpose Arithmetic and CPU Control Groups
;;

;; DAA
; Adjusts the Accumulator for BCD addition and subtraction.
; 1 Byte, 4 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00100111
;;; Condition Bits Affected
; S - set if most-significant bit of Accumulator is 1 after an operation; otherwise reset.
; Z - set if Accumulator is 0 after an operation; otherwise reset.
; H - <Explained in DAA instruction table in manual>
; P/V - set if Accumulator is at even parity after operation; otherwise reset
; C - <Explained in DAA instruction table in manual>
DAA ; 00100111

;; CPL
; Contents of Accumulator are inverted (one's complement).
; 1 Byte, 4 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00101111
;;; Condition Bits Affected
; H - set
; N - set
CPL ; 00101111

;; NEG
; Contents of Accumulator are negated (two's complement).
;; Same as subtracting the contents of the Accumulator from 0.
; 2 Bytes, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11101101 01000100
;;; Condition Bits Affected
; S - set if result is negative; otherwise reset
; Z - set if result is 0; otherwise reset.
; H - set if borrow from bit 4; otherwise reset.
; P/V - set if Accumulator was 80h before operation; otherwise reset.
; N - set
; C - set if Accumulator was not 00h before operation; otherwise reset.
NEG ; 11101101 01000100

;; CCF
; The Carry flag is inverted.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00111111
;;; Condition Bits Affected
; H - Previous carry is copied
; N - reset
; C - set if CY was 0 before operation; otherwise reset.
CCF ; 00111111

;; SCF
; The Carry flag is set.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00110111
;;; Condition Bits Affected
; H - reset
; N - reset
; C - set
SCF ; 00110111

;; NOP
; The CPU performs no operation during this machine cycle.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 00000000
NOP ; 00000000

;; HALT
; Suspends CPU operation until a subsequent interrupt or reset is received.
;; While in HALT state, processor executes NOPs to maintain memory refresh logic.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 01110110
HALT ; 01110110

;; DI
; Disables maskable interrupt (during its execution) by resetting the interrupt enable flip-flops (IFF1 and IFF2).
;; Maskable intterupt is disabled until enabled by EI.
;; CPU does not respond to an Interrupt Request (INT) signal.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 11110011
DI ; 11110011

;; EI
; Sets both interrupt enable flip-flops (IFF1 IFF2) to a logic 1, allowing recognition of any maskable interrupt.
;; During execution of this instruction and the following, maskable interrupts are disabled.
;; CPU does not respond to an Interrupt Request (INT) signal.
; 1 Byte, 1 M Cycle, 4 T States, E.T 1.00μs
; Assembled as: 11111011
EI ; 11111011

;; IM 0
; Sets Interrupt Mode 0.
;; In this mode, interrupting device can insert any instruction on the data bus for execution by CPU.
;; First byte read during intterupt acknowledge cycle.
;; Subsequent bytes read in by normal memory read request.
;; CPU does not respond to an Interrupt Request (INT) signal.
; 2 Byte, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11101101 01000110
IM 0 ; 11101101 01000110

;; IM 1
; Sets Interrupt Mode 1.
;; In this mode, processor responds to interrupt by executing restart at address 0038h.
; 2 Byte, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11101101 01010110
IM 1 ; 11101101 01010110

;; IM 2
; Sets vectored Interrupt Mode 2.
;; This mode allows indirect call to any memory location by an 8-bit vector supplied from peripheral device.
;; This vector then becomes least-significant 8-bits of the indirect pointer, while I register provides most-significant 8-bits.
;; This address points to an address in a vector table that is starting address for interrupt service routine.
; 2 Byte, 2 M Cycle, 8(4,4) T States, E.T 2.00μs
; Assembled as: 11101101 01011110
IM 2 ; 11101101 01011110
