;;
; Author: NE- https://github.com/NE-
; Date: 2022 June 28
; Purpose: Testing out the 8-Bit load group
;;

;;;
; Machine Code Representation
; BC -> 00
; DE -> 01
; HL -> 10
; SP -> 11
;;;

;; LD dd, nn
; Integer nn loaded to dd register pair.
; 3 Bytes, 2 M Cycle, 10(4,3,3) T States, E.T 2.50μs
; Assembled as: 00 dd 0001 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD HL, &2ECA ; 00 10 0001 11001010 (CAh) 00101110 (2Eh)

;; LD IX, nn
; Integer nn loaded to Index Register IX.
; 4 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11011101 00100001 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD IX, &B218 ; 11011101 00100001 00011000 (18h) 10110010 (B2h)

;; LD IY, nn
; Integer nn loaded to Index Register IY.
; 4 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11111101 00100001 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD IY, &B218 ; 111111101 00100001 00011000 (18h) 10110010 (B2h)

;; LD HL, (nn)
; Contents of memory address (nn) loaded to low-order portion L and (nn+1) loaded to high-order portion H
; 3 Bytes, 5 M Cycle, 16(4,3,3,3,3) T States, E.T 4.00μs
; Assembled as: 00101010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD HL, (&B218) ; 00101010 00011000 (18h) 10110010 (B2h)

;; LD dd, (nn)
; Contents of memory address (nn) loaded to low-order portion of dd and (nn+1) loaded to high-order portion of dd
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11101101 01 dd 1011 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD BC, (&741D) ; 11101101 01 00 1011 00011101 (1Dh) 01110100 (74h)

;; LD IX, (nn)
; Contents of memory address (nn) loaded to low-order portion IXl and (nn+1) loaded to high-order portion IXh
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11011101 00101010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD IX, (&123F) ; 11011101 00101010 00111111 (3Fh) 00010010 (12h)

;; LD IY, (nn)
; Contents of memory address (nn) loaded to low-order portion IYl and (nn+1) loaded to high-order portion IYh
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11111101 00101010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD IY, (&123F) ; 11111101 00101010 00111111 (3Fh) 00010010 (12h)

;; LD (nn), HL
; Contents of low-order portion HL (L) loaded into memory address (nn) and high-order (H) loaded into memory address (nn+1)
; 3 Bytes, 5 M Cycle, 16(4,3,3,3,3) T States, E.T 4.00μs
; Assembled as: 00100010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD (&DE46), HL ; 00100010 01000110 (46h) 11011110 (DEh)

;; LD (nn), dd
; Low-order byte of pair dd loaded into memory address (nn) upper byte loaded into (nn+1)
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11101101 01 dd 0011 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD (&984A), BC ; 11101101 01 00 0011 01001010 (4Ah) 10011000 (98h)

;; LD (nn), IX
; Low-order byte of IX loaded into memory address (nn) upper byte loaded into (nn+1)
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11011101 00100010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD (&984A), IX ; 11011101 00100010 01001010 (4Ah) 10011000 (98h)

;; LD (nn), IY
; Low-order byte of IY loaded into memory address (nn) upper byte loaded into (nn+1)
; 4 Bytes, 6 M Cycle, 20(4,4,3,3,3,3) T States, E.T 5.00μs
; Assembled as: 11111101 00100010 nnnnnnnn nnnnnnnn (LITTLE ENDIAN)
LD (&1DC7), IY ; 11111101 00100010 11000111 (C7h) 00011101 (1Dh)

;; LD SP, HL
; Contents of HL loaded into Stack Pointer SP
; 1 Byte, 1 M Cycle, 6 T States, E.T 1.50μs
; Assembled as: 11111001
LD SP, HL ; 11111001

;; LD SP, IX
; Contents of IX loaded into Stack Pointer SP
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11011101 11111001
LD SP, IX ; 11011101 11111001

;; LD SP, IY
; Contents of IY loaded into Stack Pointer SP
; 2 Bytes, 2 M Cycle, 10(4,6) T States, E.T 2.50μs
; Assembled as: 11111101 11111001
LD SP, IY ; 11111101 11111001

;; PUSH qq
; Contents of register pair qq pushed into external memory LIFO stack.
;; First decrements SP, loads high-order byte of qq into memory address specified by SP.
;; SP decremented again, loads low-order byte of qq into memory address specified by SP.
; 1 Byte, 3 M Cycle, 11(5,3,3) T States, E.T 2.75μs
;;; Cant PUSH SP so AF -> 11
; Assembled as: 11 qq 0101
PUSH BC ; 11 00 0101

;; PUSH IX
; Contents of IX pushed into external memory LIFO stack.
;; First decrements SP, loads high-order byte of IX into memory address specified by SP.
;; SP decremented again, loads low-order byte of IX into memory address specified by SP.
; 2 Bytes, 4 M Cycle, 15(4,5,3,3) T States, E.T 3.75μs
; Assembled as: 11011101 11100101
PUSH IX ; 11011101 11100101

;; PUSH IY
; Contents of IY pushed into external memory LIFO stack.
;; First decrements SP, loads high-order byte of IY into memory address specified by SP.
;; SP decremented again, loads low-order byte of IY into memory address specified by SP.
; 2 Bytes, 4 M Cycle, 15(4,5,3,3) T States, E.T 3.75μs
; Assembled as: 11111101 11100101
PUSH IY ; 11111101 11100101

;; POP qq
; Top two bytes of the stack popped to register pair qq.
;; First loads the byte at the memory location corresponding to the contents of SP to the low-order portion of qq.
;; Then SP is incremented and loads the byte at the memory location corresponding to the contents of SP to the high-order portion of qq.
;; Finally, SP is incremented again.
; 1 Byte, 3 M Cycle, 10(4,3,3) T States, E.T 2.50μs
;;; Cant POP SP so AF -> 11
; Assembled as: 11 qq 0001
POP AF ; 11 11 0001

;; POP IX
; Top two bytes of the stack popped to register IX.
;; First loads the byte at the memory location corresponding to the contents of SP to the low-order portion of IX.
;; Then SP is incremented and loads the byte at the memory location corresponding to the contents of SP to the high-order portion of IX.
;; Finally, SP is incremented again.
; 2 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11011101 11100001
POP IX ; 11011101 11100001

;; POP IY
; Top two bytes of the stack popped to register IY.
;; First loads the byte at the memory location corresponding to the contents of SP to the low-order portion of IY.
;; Then SP is incremented and loads the byte at the memory location corresponding to the contents of SP to the high-order portion of IY.
;; Finally, SP is incremented again.
; 2 Bytes, 4 M Cycle, 14(4,4,3,3) T States, E.T 3.50μs
; Assembled as: 11111101 11100001
POP IY ; 11111101 11100001
