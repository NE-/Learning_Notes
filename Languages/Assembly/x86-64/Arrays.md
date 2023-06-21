<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 August 20
  Purpose: General notes for x86-64 Arrays.
-->

# Arrays
- Continuous collection of memory cells of a **specific** type.
- Element access: Array *a* with base address *base*  uses *n* bytes per element, then *a\[i\]* is located at *base* + *i*\**n*.

## Memory References
- Arrays in text and data segments it's possible to use labels along with index register with a multiplier for element size (1, 2, 4, or 8).
- Arrays passed to functions, address must be in a register; therefore, using labels is not possible.
  - Instead, use use base register with index register (can use any of 16 general purpose, except SP as index register).
```x86asm
;;; Sample arrays
; Copy array into another in a function.
;;;

;;; Parameters
; rdi: Address of first array (source)
; rsi: Address of second array (destination)
; rdx: number of elements
;;;

copy_arr:
  xor ecx, ecx         ; Initialize for traversing
more:
  mov eax, [rsi+4*rcx] ; Store element in eax
  add rcx, 1           ; Go to next index
  cmp rcx, rdx         ; rdx - rcx
  jne more             ; If result is not 0, jump to "more"
  ; Otherwise
  xor eax, eax         ; Return 0
  ret
```

## Allocation
- Allocate memory when array size will not be known during run-time.
- Faster to assemble and link with large sized arrays. Executable is also smaller.
```x86asm
;;; Sample allocation with malloc
extern malloc
...
mov rdi, 10000000000
call malloc
mov [pointer], rax ; rax holds pointer (of allocated memory) returned by malloc.
```

```x86asm
;;; Sample array processing
; Allocate array and fill with random numbers then compute minimum
;;;

create:
  push rbp
  mov rbp, rsp
  imul rdi, 4 ; Array size * 4 (for byte adjustment)
  call malloc
  leave
  ret

fill:
.array equ 0
.size  equ 8
.i     equ 16
  push rbp
  mov rbp, rsp
  sub rsp, 32           ; 3 local variables occupy 24 bytes; subtract 32 to maintain 16 byte stack alignment.
  mov [rsp+.array], rdi ; Store address of start of array (rdi).
  mov [rsp+.size], rsi  ; Store size of array.
  xor ecx, ecx          ; Initialize ecx (index of current element).
.more
  mov [rsp+.i], rcx     ; Save index.
  call random           ; libc's random.
  mov rcx, [rsp+.i]     ; Restore index.
  mov rdi, [rsp+.array] ; Get array address.
  mov [rdi+rcx*4], eax  ; Store random number in array.
  inc rcx
  cmp rcx, [rsp+.size]  ; [rsp+.size] - rcx.
  jl .more              ; If [rsp+.size] - rcx < 0 jump to ".more".
  leave
  ret

print:
.array equ 0
.size  equ 8
.i     equ 16
  push rbp
  mov rbp, rsp
  sub rsp, 32           ; 3 local variables occupy 24 bytes; subtract 32 to maintain 16 byte stack alignment.
  mov [rsp+.array], rdi ; Store address of start of array.
  mov [rsp+.size], rsi  ; Store size of array.
  xor ecx, ecx          ; Initialize ecx (for traversing).
  mov [rsp+.i], rcx     ; Store "index".
  segment .data
.format:
  db "%10d",0x0a,0
  segment .text
.more
  lea rdi, [.format]    ; printf arg 1 (const char* fmt).
  mov rdx, [rsp+.array] ; Get array address.
  mov rcx, [rsp+.i]     ; Get array index.
  mov esi, [rdx+rcx*4]  ; Get element.
  mov [rsp+.i], rcx     ; Store index into variable.
  call printf
  mov rcx, [rsp+.i]     ; Retrieve index
  inc rcx               ; Increment index
  mov [rsp+.i], rcx     ; Save index
  cmp rcx, [rsp+.size]  ; [rsp+.size] - rcx
  jl .more              ; If [rsp+.size] - rcx < 0 jump to ".more".
  leave
  ret

min:
  ; Doesn't call any other function therefore epilogue not required
  mov eax, [rdi]        ; Get array address.
  mov rcx, 1            ; Initialize rcx (traversing).
.more
  mov r8d, [rdi+rcx*4]  ; Get element
  cmp r8d, eax          ; eax - r8
  cmovl eax, r8d        ; If eax - r8 < 0 mov eax, r8d
  inc rcx
  cmp rcx, rsi          ; rsi - rcx
  jl .more              ; If rsi - rcx < 0 jump to ".more".
  ret

main:
.array equ 0
.size equ 8
  push rbp
  mov rbp, rsp
  sub rsp, 16           ; Allocate for local variables.
  mov ecx, 10           ; Default size
  mov [rsp+.size], rcx
  cmp edi, 2            ; Check if argv[1] was given
  jl .nosize            ; If no size given, jump to .nosize
  ; Otherwise
  mov rdi, [rsi+8]      ; Store given size
  call atoi             ; Convert string to integer type. libc.
  mov [rsp+.size], rax  ; Store returned result.

.nosize:
  mov rdi, [rsp+.size]  ; Prepare to create array.
  call create
  mov [rsp+.array], rax ; Save returned result.
  mov rdi, rax          ; Store address to destination register
  mov rsi, [rsp+.size]  ; Store size in rsi (argument to "fill" subroutine).
  call fill

  mov rsi, [rsp+.size]  ; Get size
  cmp rsi, 20           ; 20 - rsi
  jg .toobig            ; If 20 - rsi > 0 print the minimum
  ; Otherwise
  mov rdi, [rsp+.array] ; Get address of array
  call print

.toobig:
  segment .data
.format:
  db "min: %ld",0x0a,0

  segment .text
  mov rdi, [rsp+.array] ; Get array address
  mov rsi, [rsp+.size]  ; Get array size
  call min              ; Find minimum
  lea rdi, [.format]    ; Prepare format for printing
  mov rsi, rax          ; Store result of "min" for printing
  call printf
  leave
  ret
```

## Command Line Parameter Array
- Available to a C program as parameters to *main*.
- Number of command line parameters is first argument, array of character pointers is second argument.
  - First parameter is always name of executable being run.
- **argv** is passed by placing address of first element in register or stack.
  - **argv**'s address is in rsi.
```x86asm
;;; Sample Command Line Parameters
; Prints all argv contents
;;;

  segment .data
format db "%s",0x0a,0

  segment .text
  global main
  extern printf

main:
  push rbp
  mov rbp, rsp
  sub rsp, 16       ; Allocate memory.
  mov rcx, rsi      ; Store address of argv.
  mov rsi, [rcx]    ; Store contents of rcx in rsi.
start_loop:
  lea rdi, [format] ; Get format for printf.
  mov [rsp], rcx    ; Save argv
  call printf
  mov rcx, [rsp]    ; Retrieve current argv address
  add rcx, 8        ; Advance to next pointer
  mov rsi, [rcx]    ; Store contents of rcx in rsi.
  cmp rsi, 0        ; 0 - rsi
  jnz start_loop    ; If 0 - rsi is not 0 (NULL) jump to start_loop.
end_loop:
  xor eax, eax      ; Return 0
  leave
  ret
```