;;;
;  Author:  NE- https://github.com/NE-
;  Date:    2023 December 06
;  Purpose: Linear Search implementation for DMG GameBoy ("GBZ80")
;
;  Notes: 
;    - Compiled with vasm
;      - Header generated by rgbfix
;    - Ran with BGB emulator
;    - There are no visuals
;;;

  org &0000

  ; Interrupts unused
  org &0040
    reti
  org &0048
    reti
  org &0050
    reti
  org &0058
    reti
  org &0060
    reti

  org &0100
    di
    jp main

;;;
; Header is generated by rgbfix
;;;

  org &0150
main:
  ; Initialize data
  ld b, 47         ; Number to find
  ld c, EndArr-arr ; Length - 1
  dec c
  ld hl, arr       ; Pointer to array

traverseArr:
  ldi a, (hl)    ; Get current element
  cp b           ; Compare with element we want
  jr z, Found
  dec c          ; Reduce length for loop termination
  ld a, $FF      ; Test if c underflowed
  cp c
  jr z, inf      ; If so, element not found. Return -1.

  jr traverseArr ; Otherwise keep on checking

Found:
  ; Get distance traveled from beginning of array
  dec l      ; Make up for ldi
  ld a, l
  ld b, <arr ; Get low-byte of array address
  sub b      ; Saves result (index) in accumulator
  jr inf

inf: 
  jr inf

arr:
  db 2,6,11,16,19,25,47,49,53
EndArr: