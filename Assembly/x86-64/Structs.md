<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 28
  Purpose: General notes for x86-64 Structs.
-->

# Structs
- Basically keep track of the offsets of each struct item.
```asm
;;; C struct in assembly
; struct {
;   int id;
;   char name[64];
;   char address[64];
;   int balance;
; };
;;;

mov rdi, 136       ; size of Customer
call malloc
mov [c], rax       ; save address
mov rax, dword 7   ; set id
lea rdi, [rax+4]   ; get name
lea rsi, [name]    ; name to copy
call strcpy
mov rax, [c]       ; recover base memory address
lea rdi, [rax+68]  ; address field location
lea rsi, [address] ; address to copy
call strcpy
mov rax, [c]
mov edx, [balance] 
mov [rax+132], edx ; set balance
```
## Symbolic Names for Offsets
- Having literals is bad practice, so we use symbolic names instead.
- In yasm, start a struct with `struc` and close it with `endstruc`.
```asm
        struc Customer
id      resb  1
name    resb  64
address resb  64
balance resd  1
        endstruc
```
- Doing the above makes the names **global**, so we have to prefix them.
```asm
;; Prefixing prevents global names
        struc Customer
.id      resb  1
.name    resb  64
.address resb  64
.balance resd  1
        endstruc

;; Usage
Customer.id
```
- yasm also defines `Customer_size` to be number of bytes in the struct (good for memory allocation).
```asm
;; Struct initialization example
        segment .data
name    db    "Calvin", 0
address db    "12 Mockingbird Lane", 0
balance dd    12500

        struc Customer
c_id      resd 1
c_name    resb 64
c_address resb 64
c_balance resd 1
        endstruc
c       dq 0

        segment .text
        global main
        extern malloc, strcpy
main:   push rbp
        mov rbp, rsp
        sub rsp, 32              ; prepare for memory allocation
        mov rdi, Customer_size   ; allocate 1 struct
        call malloc
        mov [c], rax             ; save base pointer
        mov [rax+c_id], dword 7  ; set id
        lea rdi, [rax+c_name]
        lea rsi, [name]          ; prepare for string copying
        call strcpy
        mov rax, [c]             ; restore base pointer
        lea rdi, [rax+c_name]
        lea rsi, [address]       ; prepare for string copying
        call strcpy
        mvo rax, [c]             ; restore base pointer
        mov edx, [balance]
        mov [rax+c_balance], edx ; set balance
        xor eax, eax             ; return 0
        leave
        ret
```
- Alignment is different from C; 1 byte larger increases offset by 4 (C) assembly increases by 1.
```asm
;;; C-aligned struct
c istruc Customer
  iend

c  istruc  Customer
   at c_id,      dd 7
   at c_name,    db "Calvin",0
   at c_address, db "12 Mockingbird Lane",0
   at c_balance, dd 12500
   iend
```

## Allocating and Array of Struct
- Multiply size of struct times number of elements to allocate enough space.
- C aligns data on appropriate boundaries so we must align each element to the largest data item in the struct.
  - quad word fields must be aligned by 8 for the size to be a multiple of 8.
  - double word align 4.
  - word align 2.
```asm
;;; Allocating an array of structs

          segment .data
          struc Customer
c_id      resd  1  ;   4 bytes
c_name    resb  65 ;  69 bytes
c_address resb  65 ; 134 bytes
          align 4  ; align to 136
c_balance resd  1  ; 140 bytes
c_rank    resb  1  ; 141 bytes
          align 4  ; align to 144
          endstruc
customers dq 0
          segment .text
          mov edi, 100             ; store 100 structs
          mul edi, Customer_size   ; prepare for allocation
          call malloc
          mov [customers], rax     ; save pointer to array

          segment .data
format db "%s %s %d",0x0a,0
          segment .text
          push r15                 ; save r15 state
          push r14                 ; save r14 state
          mov r15, 100             ; use as counter
          mov r14, [customers]     ; restore pointer
more      lea edi, [format]        ; load print format
          lea esi, [r14_c_name]    ; '%s'
          lea rdx, [r14+c_address] ; '%s'
          mov rcx, [r14+c_balance] ; '%d'
          call printf
          add r14, Customer_size   ; point to the next index/customer
          sub r15, 1               ; decrement counter
          jnz more                 ; print next record if r15 > 0
          pop r14                  ; restore previous r14
          pop r15                  ; restore previous r15
          ret                      ; leave function
```