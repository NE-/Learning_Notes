;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 16
; Purpose: Testing out the Compare and Test group
;;

;; BCC
; Branch if C = 0.
;; Carry Clear.
; Compiled as: 10010000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BCC loop ; 10010000 <varies>

;; BCS
; Branch if C = 1.
;; Carry Set.
; Compiled as: 10110000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BCS loop ; 10110000 <varies>

;; BNE
; Branch if Z = 0.
;; Not Equal (Not zEro).
; Compiled as: 11010000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BNE loop ; 10010000 <varies>

;; BEQ
; Branch if Z = 1.
;; EQual (result zero).
; Compiled as: 11110000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on next page.
BEQ loop ; 11110000 <varies>

;; BPL
; Branch if N = 0.
;; PLus (positive).
; Compiled as: 00010000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BPL loop ; 00010000 <varies>

;; BMI
; Branch if N = 1.
;; MInus (negative).
; Compiled as: 00110000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BMI loop ; 00110000 <varies>

;; BVC
; Branch if V = 0.
;; oVerflow Clear.
; Compiled as: 01010000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BVC loop ; 01010000 <varies>

;; BVS
; Branch if V = 1.
;; oVerflow Set.
; Compiled as: 01110000
;; Relative: [2 Bytes 2* Cycles]
;; * Add 1 if branch occurs on same page.
;; * Add 2 if branch occurs on different page.
BVS loop ; 01110000 <varies>
