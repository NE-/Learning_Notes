;;
; Author:  NE- https://github.com/NE-
; Date:    2022 July 03
; Purpose: Testing out the Input and Output Group
;;

;;;
; Machine Code Representation
; Flag -> 110 Undefined op code; set the flag
; B -> 000
; C -> 001
; D -> 010
; E -> 011
; H -> 100
; L -> 101
; A -> 111
;;;

;; IN A, n
; n placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; Contents of Accumulator also appear on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to Accumulator.
; 2 Bytes, 3 M Cycle, 11(4,3,4) T States, E.T 2.75μs
; Assembled as: 11011011 nnnnnnnn
IN A, (12) ; 11011011 00001100

;; IN r, (C)
; Contents in C are placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; Contents of B are placed on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to register r.
; 2 Bytes, 3 M Cycle, 12(4,4,4) T States, E.T 3.00μs
; Assembled as: 11101101 01 rrr 000
;;; Condition Bits Affected
; S - set if input data is negative; otherwise reset
; Z - set if input data is 0; otherwise reset
; H - reset
; P/V - set if parity even; otherwise reset
; N - reset
IN A, (C) ; 11101101 01 111 000

;; INI
; Contents in C are placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B used as byte counter, and its contents are placed on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to the CPU.
; Contents of HL placed on address bus and the input byte written to corresponding location of memory.
; byte counter decremented, HL incremented.
; 2 Bytes, 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10100010
;;; Condition Bits Affected
; S - unknown
; Z - set if B-1 = 0; otherwise reset
; H - unknown
; P/V - unknown
; N - set
INI ; 11101101 10100010

;; INIR
; Contents in C are placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B used as byte counter, and its contents are placed on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to the CPU.
; Contents of HL placed on address bus and the input byte written to corresponding location of memory.
; HL incremented, byte counter decremented.
;; If decrementing causes B to go to 0, instruction is terminated
;; Else PC decremented by 2 and the instruction is repeated.
;;; Interrupts are recognized and 2 refresh cycles execute after each data transfer.
;;; If B is set to 0 prior to instruction execution, 256 bytes of data are input.
; 2 Bytes, 
; If B != 0: 5 M Cycle, 21(4,5,3,4,5) T States, E.T 5.25μs
; Else: 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10110010
;;; Condition Bits Affected
; S - unknown
; Z - set
; H - unknown
; P/V - unknown
; N - set
INIR ; 11101101 10110010

;; IND
; Contents in C are placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B used as byte counter, and its contents are placed on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to the CPU.
; Contents of HL placed on address bus and the input byte written to corresponding location of memory.
; byte counter decremented, HL decremented.
; 2 Bytes, 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10101010
;;; Condition Bits Affected
; S - unknown
; Z - set if B-1 = 0; otherwise reset
; H - unknown
; P/V - unknown
; N - set
IND ; 11101101 10101010

;; INDR
; Contents in C are placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B used as byte counter, and its contents are placed on top half (A8 through A15) of the address bus at this time.
; Then one byte from the selected port is placed on the data bus and written to the CPU.
; Contents of HL placed on address bus and the input byte written to corresponding location of memory.
; HL decremented, byte counter decremented.
;; If decrementing causes B to go to 0, instruction is terminated
;; Else PC decremented by 2 and the instruction is repeated.
;;; Interrupts are recognized and 2 refresh cycles execute after each data transfer.
;;; If B is set to 0 prior to instruction execution, 256 bytes of data are input.
; 2 Bytes, 
; If B != 0: 5 M Cycle, 21(4,5,3,4,5) T States, E.T 5.25μs
; Else: 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10111010
;;; Condition Bits Affected
; S - unknown
; Z - set
; H - unknown
; P/V - unknown
; N - set
INIR ; 11101101 10110010

;; OUT (n), A
; n placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; Contents of Accumulator also appear on top half (A8 through A15) of the address bus at this time.
; Then the byte contained in the Accumulator placed on data bus and written to selected peripheral device.
; 2 Bytes, 3 M Cycle, 11(4,3,4) T States, E.T 2.75μs
; Assembled as: 11010011 nnnnnnnn
OUT (15), A ; 11010011 00001111

;; OUT (C), r
; Contents of register C placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; Contents of B also appear on top half (A8 through A15) of the address bus at this time.
; Then the byte contained in r placed on data bus and written to selected peripheral device.
; 2 Bytes, 3 M Cycle, 12(4,4,4) T States, E.T 3.00μs
; Assembled as: 11011011 01 rrr 001
OUT (C), H ; 11011011 01 100 001

;; OUTI
; Contents of HL are placed on address bus to select location in memory. Bytes in this location temporarily stored in CPU.
; B decremented, C placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B can be used as byte counter, and its decremented value placed on top half (A8 - A15) of address bus.
; Byte to be output placed on data bus and written to a selected peripherial device.
; HL incremented.
; 2 Bytes, 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10100011
;;; Condition Bits Affected
; S - unknown
; Z - set if B-1 = 0; otherwise reset
; H - unknown
; P/V - unknown
; N - set
OUTI ; 11101101 10100011

;; OTIR
; Contents of HL are placed on address bus to select location in memory. Bytes in this location temporarily stored in CPU.
; B decremented, C placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B can be used as byte counter, and its decremented value placed on top half (A8 - A15) of address bus.
; Byte to be output placed on data bus and written to a selected peripherial device.
; HL incremented.
;; If decremented B is not 0, PC decremented by two and instruction repeated.
;; Else: instruction is terminated.
;;; Interrupts are recognized and two refresh cycles are executed after each data transfer.
; 2 Bytes, 
; If B != 0: 5 M Cycle, 21(4,5,3,4,5) T States, E.T 5.25μs
; Else: 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10110011
;;; Condition Bits Affected
; S - unknown
; Z - set 
; H - unknown
; P/V - unknown
; N - set
OTIR ; 11101101 10110011

;; OUTD
; Contents of HL are placed on address bus to select location in memory. Bytes in this location temporarily stored in CPU.
; B decremented, C placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B can be used as byte counter, and its decremented value placed on top half (A8 - A15) of address bus.
; Byte to be output placed on data bus and written to a selected peripherial device.
; HL decremented.
; 2 Bytes, 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10101011
;;; Condition Bits Affected
; S - unknown
; Z - set if B-1 = 0; otherwise reset
; H - unknown
; P/V - unknown
; N - set
OUTD ; 11101101 10101011

;; OTDR
; Contents of HL are placed on address bus to select location in memory. Bytes in this location temporarily stored in CPU.
; B decremented, C placed bottom half (A0 through A7) of the address bus to select I/O device at one of 256 possible ports.
; B can be used as byte counter, and its decremented value placed on top half (A8 - A15) of address bus.
; Byte to be output placed on data bus and written to a selected peripherial device.
; HL decremented.
;; If decremented B is not 0, PC decremented by two and instruction repeated.
;; Else: instruction is terminated.
;;; Interrupts are recognized and two refresh cycles are executed after each data transfer.
; 2 Bytes, 
; If B != 0: 5 M Cycle, 21(4,5,3,4,5) T States, E.T 5.25μs
; Else: 4 M Cycle, 16(4,5,3,4) T States, E.T 4.00μs
; Assembled as: 11101101 10111011
;;; Condition Bits Affected
; S - unknown
; Z - set 
; H - unknown
; P/V - unknown
; N - set
OTDR ; 11101101 10111011