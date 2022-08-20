<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 19
  Purpose: General notes for x86-64 Functions.
-->

# Functions
## The Stack
- "Stack randomization" may occur to prevent rogue code from modifying stack values.
- `push` subtracts 8 from rsp and then place value being pushed to that \[rsp-8\] address.
  - Assume 0x7FFFFFFFF000. 
  - 0x7FFFFFFFF000 - 8 = 0x7FFFFFFFEFF8.
  - 8 byte value stored in 0x7FFFFFFFEFF8 through 0x7FFFFFFFEFFF.
- `pop` moves value at location specified by rsp to a register or memory location and then adds 8 to rsp. *Opposite of `push`!*
- You can push/pop values smaller than 8 bytes, but make sure stack is bounded to size N bytes otherwise operation may fail.
  - Best to just push/pop 8 bytes!

## Call
- `call` used to call a function.
- Pushes address of the instruction following the call onto the stack (AKA *return address*) and transfer control to address associated with the called function.
```asm
;;; Basic implementation of call
; Best to just use call
;;;

  push next_instruction ; (rip + 2 instructions)
  jmp my_function
next_instruction:
  ...
```
## Return
- `ret` used to return from a function.
- Pops address from top of stack and transfers control to that address.
- `retf` pops IP followed by CS.
- `retn` only pops IP.

## Parameters and Return Value
- Linux uses System V Application Binary Interface function call protocol.
  - Allows first 6 integer parameters to be passed in registers (rdi,rsi,rdx,rcx,r8,r9).
    - Any more pushed onto stack in reverse order.
  - Allows first 8 floating point parameters to be passed in registers (xmm0-xmm7).
  - Uses rax for integer return.
  - Uses xmm0 for floating point return.
- Windows uses Microsoft x64 Calling Convention function call protocol.
  - Allows first 4 integer parameters to be passed in registers (rcx,rdx,r8,r9).
    - Any more pushed onto stack in reverse order.
  - Allows first 4 floating point parameters to be passed in registers (xmm0-xmm3).
  - Uses rax for integer return.
  - Uses xmm0 for floating point return.
- Both Windows and Linux expect SP to be maintained 16 byte boundaries.
  - rsp should end in 0x0.
  - Allows local variables in functions to be placed in 16 byte alignments for SSE and AVX instructions.
  - Executing `call` would decrement rsp by 8, making it end in 0x8.
    - Conforming functions should either push or subtract from rsp to get it back to a 16 byte boundary. Used with function call inside a function.
- Number of floating point parameters required in a function call (e.g. printf scanf) are stored in rax.
```asm
;;; Sample system function call
; Hello World example
;;;

      section .data
msg:  db      "Hello World",0x0a,0

      section .text
      global main
      extern printf  ; Let assembler know of printf's existence

main:
      push rbp       ; Push rbp immediately below return address.
      mov rbp, rsp   ; Make rbp point to pushed rbp object.
      lea rdi, [msg] ; Store address of first character.
      xor eax, eax   ; 0 floating point parameters
      call printf
      xor eax, eax   ; return 0
      pop rbp        ; Restore the stack
      ret
```

## Stack Frame
- Start with standard `push rbp mov rbp, rsp`.
  - Creates a linked list of objects (function invocation) on the stack.
    - Greatefor the debugger: allows for backtracing, identifying functions, and line number.
- End with `mov rsp, rbp pop rbp` (opposite of prologue).
- If too many local variables or functions call other functions, you may need to allocate space on stack.
  - Subtract from rsp to allocate.
  ```asm
  ;;; Sample allocate on stack
  push rbp
  mov rbp, rsp
  sub rsp, 32 ; Allocate 32 bytes (multiple of 16).
  ...
  leave       ; Undo prologue
  ret
  ```
- "Leaf" functions don't require prologue or `leave`.
- Can also be omitted in general, though gdb won't be able to backtrace.
### Variables
- Referenced using rbp.
  - Uses right-to-left calling convention (CDECL) so the left-most argument will be at the top.
```asm
;;; Rough stack representation. Assume 8 byte bounded stack.
[rbp+32] ; 3rd argument
[rbp+24] ; 2nd argument
[rbp+16] ; 1st argument
[rbp+8]  ; return address (pre call eip + 2)
[rbp]    ; Old rbp value
[rbp-8]  ; 1st local variable
[rbp-16] ; 2nd local variable
...
[rbp-X]  ; Current stack pointer
```
- Must specify which registers must be preserved.
  - System V ABI: rbx, rbp, r12-r15.
  - Windows rbx, rbp, rsi, rdi, r12-r15.

## Recursion
- Generally require stack frames with local variable storage for each stack frame.
```asm
;;; Sample recursion
; Computes n!
;;;

        segment .data
x             dq  0
scanf_format  db "%ld", 0
printf_format db "fact(%ld) = %ld",0x0a,0

        segment .text
        global main
        global fact
        extern scanf  ; Exists in libc
        extern printf ; Exists in libc

main:
        push  rbp
        mov   rbp, rsp
        lea   rdi, [scanf_format]  ; scanf arg 1 (const char* format).
        lea   rsi, [x]             ; scanf arg 2 (allocated object to hold input).
        xor   eax, eax             ; 0 float parameters in scanf.
        call  scanf

        mov   rdi, [x]             ; Use 'x' for fact
        call  fact

        lea   rdi, [printf_format] ; printf arg 1 (const char* format).
        mov   rsi, [x]             ; printf arg 2 (allocated object to print. Our input).
        mov   rdx, rax             ; printf arg 3 (allocated object to print. Return of fact call AKA x!).
        xor   eax,eax              ; 0 float parameters in printf.
        call  printf

        xor   eax,eax              ; return 0
        leave
        ret

fact:
n       equ   8                    ; Local variable. equ is *assembler* pseudo-op.
        push  rbp
        mov   rbp,rsp
        sub   rsp, 16              ; Allocate for n
        cmp   rdi, 1 ; 1 - rdi
        jg    greater              ; if 1 - rdi > 0 go to "greater"

        ; Otherwise
        mov   eax, 1 ; Return 1
        leave
        ret

greater:
        mov   [rsp+n], rdi         ; Save rdi in "n"
        dec   rdi                  ; Prepare to call fact with n-1
        call  fact                 ; Recurse
        mov   rdi, [rsp+n]         ; Restore original "n"
        imul  rax, rdi             ; Multiply fact(n-1)*n
        leave 
        ret
```