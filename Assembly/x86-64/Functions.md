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

  push next_instruction
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

  