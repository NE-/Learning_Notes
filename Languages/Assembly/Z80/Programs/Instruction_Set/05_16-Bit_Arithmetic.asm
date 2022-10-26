;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 01
; Purpose: Testing out the General-Purpose Arithmetic and CPU Control Groups
;;

;;;
; Machine Code Representation
; BC -> 00
; DE -> 01
; HL -> 10
; SP -> 11
;;;

;; ADD HL, ss
; Contents of register pair ss (BC DE HL SP) are added to HL.
;; Result stored in HL
; 1 Byte, 3 M Cycle, 11(4,4,3) T States, E.T 2.75μs
; Assembled as: 00 ss 1001
;;; Condition Bits Affected
; H - set if carry from bit 11; otherwise reset
; N - reset
; C - set if carry from bit 15; otherwise reset
ADD HL, DE ; 00 01 1001

;; ADC HL, ss
; Contents of register pair ss (BC DE HL SP) are added with the Carry flag to HL.
;; Result stored in HL
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11101101 01 ss 1010
;;; Condition Bits Affected
; S - set if result negative; otherwise reset
; Z - set if result 0; otherwise reset
; H - set if carry from bit 11; otherwise reset
; P/V - set if overflow; otherwise reset
; N - reset
; C - set if carry from bit 15; otherwise reset
ADC HL, SP ; 11101101 01 11 1010

;; SBC HL, ss
; Contents of register pair ss (BC DE HL SP) and the Carry flag are subtracted to HL.
;; Result stored in HL
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11101101 01 ss 0010
;;; Condition Bits Affected
; S - set if result negative; otherwise reset
; Z - set if result 0; otherwise reset
; H - set if borrow from bit 12; otherwise reset
; P/V - set if overflow; otherwise reset
; N - set
; C - set if borrow; otherwise reset
SDC HL, BC ; 11101101 01 00 0010

;; ADD IX, pp
; Contents of register pair pp (BC DE IX SP) are added to contents of IX
;; Result stored in IX
;;;
; Machine Code Representation
; BC -> 00
; DE -> 01
; IX -> 10
; SP -> 11
;;;
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11011101 00 pp 1001
;;; Condition Bits Affected
; H - set if carry from bit 11; otherwise reset
; N - reset
; C - set if carry from bit 15; otherwise reset
ADD IX, IX ; 11011101 00 10 1001

;; ADD IY, rr
; Contents of register pair rr (BC DE IY SP) are added to contents of IY
;; Result stored in IY
;;;
; Machine Code Representation
; BC -> 00
; DE -> 01
; IY -> 10
; SP -> 11
;;;
; 2 Bytes, 4 M Cycle, 15(4,4,4,3) T States, E.T 3.75μs
; Assembled as: 11111101 00 rr 1001
;;; Condition Bits Affected
; H - set if carry from bit 11; otherwise reset
; N - reset
; C - set if carry from bit 15; otherwise reset
ADD IY, DE ; 11111101 00 01 1001

;; INC ss
; Contents of register pair ss (BC DE HL SP) are incremented.
; 1 Byte, 1 M Cycle, 6 T States, E.T 1.50μs
; Assembled as: 00 ss 0011
INC HL ; 00 10 0011

;; INC IX
; Contents of IX are incremented.
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11011101 00100011
INC IX ; 11011101 00100011

;; INC IY
; Contents of IY are incremented.
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11111101 00100011
INC IY ; 11111101 00100011

;; DEC ss
; Contents of register pair ss (BC DE HL SP) are decremented.
; 1 Byte, 1 M Cycle, 6 T States, E.T 1.50μs
; Assembled as: 00 ss 1011
DEC SP ; 00 11 1011

;; DEC IX
; Contents of IX are decremented.
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11011101 00101011
DEC IX ; 11011101 00101011

;; DEC IY
; Contents of IY are decremented.
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11111101 00101011
DEC IY ; 11111101 00101011