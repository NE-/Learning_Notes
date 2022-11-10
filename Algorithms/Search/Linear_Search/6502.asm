;;;
;  Author: NE- https://github.com/NE-
;  Date: 2022 November 10
;  Purpose: Linear Search implementation in 6502 Assembly
;
;  Notes: Compiled and ran with easy6502 simulator
;         https://skilldrick.github.io/easy6502/simulator.html
;;;

define val $0 ; Element to find
define n   $1 ; Length of array

; Initialize
lda #47 ; Element to find
sta val
lda #9  ; Length of array
sta n
ldx #0  ; For traversing the array

for:
  ; Check if i >= n, exit if so
  cpx n
  bcs not_found

  lda arr, x
  ; If A[i] == val
  cmp val
  beq found
  inx       ; ++i
  jmp for

found:
  txa       ; Save index in Accumulator
  rts
not_found:
  lda #$FF  ; Return -1
  rts

arr:
  dcb 2, 6, 11, 16, 19, 25, 47, 49, 53