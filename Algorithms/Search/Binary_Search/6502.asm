;;;
;  Author: NE- https://github.com/NE-
;  Date: 2022 November 04
;  Purpose: Binary Search implementation in 6502 Assembly
;
;  Notes: Compiled and ran with easy6502 simulator
;         https://skilldrick.github.io/easy6502/simulator.html
;;;

; Variables
define start $0 
define mid   $1
define end   $2
define el    $3 ; Element to find

; initialize
lda #0
sta start
sta mid
lda #9      ; Length of array
sta end
lda #34     ; Element to find
sta el

while:
  ; Check if start <= end
  lda start
  cmp end
  bcs done
  
  ; mid = (start + end) / 2
  lda start
  clc
  adc end   ; start + end
  lsr       ; Divide by 2
  sta mid   ; Save result

  ldx mid
  lda arr,x
  cmp el
  ; if (arr[mid] == x)
  beq found
  ; else if (x < arr[mid])
  bpl bottom
  ; else
  ;; start = mid + 1
  ldx mid
  inx       ; mid + 1
  stx start ; Save result

  jmp while

bottom:
  ; end = mid - 1
  ldx mid
  dex       ; mid - 1
  stx end   ; Save result
  jmp while

found:
  ; Store return result in accumulator
  lda mid
  brk

done:
  ; Element was not found; return -1
  lda #$ff
  brk

arr:
  dcb 1,4,15,27,29,34,36,57,68 
