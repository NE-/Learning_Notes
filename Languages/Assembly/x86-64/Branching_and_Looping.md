<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 August 18
  Purpose: General notes for the x86-64 Branching instructions.
-->

# Unconditional Jump
## `jmp` 
  - `jmp [8-bit signed imm]` encoded as 2 Bytes. Allows for jumping ±127 bytes.
  - 64-bit mode uses 32 bit signed imm. and is encoded as 5 bytes.
    - Assembler chooses appropriate/efficient one.
  - CPU tansfers control to instruction at labeled address.

# Conditional Jump
- Jumps based on set and/or unset flags.
- `cmp` allows for subtraction without modifying a register (second operand minus first) and sets the appropriate flags.
## Condition Codes
| Instruction | Meaning | Aliases | Flags |
| ----------- | ------- | ------- | ----- |
| `jz` | Jump if zero | `je` | ZF=1 |
| `jnz` | Jump if not zero | `jne` | ZF=0 |
| `jg` | Jump if > zero | `jnle` | ZF=0, SF=0 |
| `jge` | Jump if >= zero | `jnl` | SF=0 |
| `jl` | Jump if < zero | `jnge` `js` | SF=1 |
| `jle` | Jump if <= zero | `jng` | ZF=1 or SF=1 |
| `jc` | Jump if carry | `jb` `jnae` | CF=1 |
| `jnc` | Jump if not carry | `jae` `jnb` | CF=0 |
```x86asm
;;; Sample 'if' statement

  ; Store variables in a register
  mov rax, [a]
  mov rbx, [b]

  cmp rax,rbx ; rbx - rax
  jge ordered ; If rbx - rax did not result in a negative
              ; this means rbx > rax so jump to "ordered" label
  ; Otherwise swap them
  mov [a], rbx 
  mov [b], rax

ordered:
  ...
```

```x86asm
;;; Sample 'if-else' statement

  ; Store variables in a register
  mov rax, [a]
  mov rbx, [b]

  cmp rax,rbx ; rbx - rax
  jnl else    ; If rbx - rax not less than zero
              ; jump to "else" label
  ; Otherwise
  mov [max], rbx
  jmp endif
else: 
  mov [max], rax
endif:
  ...
```

```x86asm
;;; Sample "if elif else" statement

  ; Store variables in a register
  mov rax, [a]
  mov rbx, [b]

  cmp rax, rbx ; rbx - rax
  jnl else_if  ; If not less than zero
               ; Jump to "else_if"
  ; Otherwise
  mov qword [res], 1
  jmp endif

else_if:
  mov rcx, [c]
  cmp rax, rcx ; rcx - rax
  jng else     ; If not greater than zero (negative)
               ; jump to "else"
  ; Otherwise
  mov qword [res], 2
  jmp endif

else:
  mov qword [res], 3
end_if:
  ...
```

# Looping
- In short, jumping backwards.

```x86asm
;;; Sample "while" loop
; Count set bits in a QW
;;;

  ; Initialize registers
  mov rax, [data]
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

while:
  cmp rcx, 64   ; 64 - rcx
  jnl end_while ; If 64 - rcx is not less than zero
                ; jump to "end_while"
  ; Otherwise
  bt rax, 0     ; Test bit 0. CF = that bit
  setc bl       ; Set bl to contents of CF
  add edx, ebx  ; add result (0 or 1) to edx
  shr rax, 1    ; Shift rax contents by 1. 
                ; Modifies carry with last shifted bit.
  inc rcx       ; Increment contents of rcx by 1.
  jmp while

end_while:
  mov [sum], rdx
  xor eax, eax
  leave
  ret
```

```x86asm
;;; Sample do-while loop
; Find a character in a string
;;;

  ; Initialize registers
  mov bl, [a]
  xor ecx, ecx
  mov al, [data+rcx]

  cmp al, 0    ; 0 - al
  jz end_while ; If al == 0 jump to end_while

  ; Otherwise
while:
  cmp al, bl         ; bl - al
  je found           ; If bl - al resulted in 0 (equal), jump to "found"
  inc rcx            ; Increment rcx for next char
  mov al, [data+rcx] ; Store next character in al
  cmp al, 0          ; 0 - al
  jnz while          ; If al - 0 did not result in 0, go back to "while"
                     ; '0' is null terminator for the string

end_while:
  mov rcx, -1        ; Character was not found in string
found:
  mov [n], rcx       ; Store result in 'n'
  xor eax, eax
  leave 
  ret
```

```x86asm
;;; Sample counting (for) loop
; Array addition
;;;

  ; Initialize registers
  mov rdx, [n] ; Store array length in rdx
  xor ecx, ecx

for: 
  cmp rcx, rdx       ; rdx - rcx
  je end_for         ; If rdx - rcx resulted in 0 (equal), jump to end_for
  mov rax, [a+rcx*8] ; Get element in array a
  add rax, [b+rcx*8] ; Get element in array b
  mov [c+rcx*8], rax ; Store result in array c
  inc rcx            ; Go to next index
  jmp for            ; repeat
end_for:
  ...
```

## Loop Instruction
- `loop` instruction decrements rcx and branches until rcx reaches 0.
  - **5 times faster to just subtract 1 from rcx and use jnz instead**!
  - Limited to branching 8 bits (±127).
```x86asm
;;; Sample using loop
; Find right-most occurence of character in an array
;;;

  mov ecx, [n] ; Store array length
more:
  cmp [data+rcx-1], al ; al - [data+rcx-1]
  je found             ; If al - [data+rcx-1] resulted in 0 (equal) jump to "found"

  ; Otherwise
  loop more
found:
  sub ecx, 1
  mov [loc], ecx
```

## Repeat string/array Instructions
- `rep` repeats string instruction n-times (specified in rcx).

### String Instructions
- Suffixed with: b (1 byte),w (2 bytes),d (4 bytes),q (8 bytes) for element size. 1,2,4 byte quantities encoded in 1 byte and 8 byte encoded as 2 bytes (efficient!).
- Use rax, rsi, and rdi for special purposes.
  - rax (eax, ax, al) holds specific value.
  - rsi source index.
  - rdi destination index.
- rsi and rdi updated after each use (managed by Direction Flag).
  - If DF is 0, registers **increased** by size of data (b,w,d,q).
  - If DF is 1, registers **decreased** by size of data (b,w,d,q).

#### Move
- `movsb` moves bytes from address specified in rsi to address specified in rdi.
- `movs` moves 2, 4, or 8 byte data from \[rdi\] to \[rsi\].
- Data moved is not stored in a register and no flags are affeted.
- After data moved, rdi and rsi are advanced 1,2,4, or 8 bytes (depending on data size).
```x86asm
;;; Sample movsb
; Move 100000 bytes from one array to another
;;;

lea rsi, [src]  ; Load address into rsi.
lea rdi, [dst]  ; Load address into rdi.
mov rcx, 100000 ; Initialize rcx.
rep movsb       ; Repeat a movsb until rcx is 0.
```

#### Store
- `stosb` moves byte in register al to address specified in rdi.
  - Other variants can use ax, eax, or rax.
- No flags affected.
- Useful for filling arrays with a single value.
- Useful for non-repeat loops for taking advantage of automatic destination register updating.
```x86asm
;;; Sample stosd
; Fill array of 1000000 DW with 1.
;;;

mov eax, 1             ; Number to fill with
mov ecx, 1000000       ; Size of array
lea rdi, [destination] ; Load address to Destination Index
rep stosd              ; repeat stosd
```

#### Load
- `lodsb` moves byte from address specified by rsi to al.
  - Other variants move more data into ax, eax, or rax.
- No flags affected.
- Not many practical uses, however, `lods` can be used in loops taking advantage of automatic source register updating.
```x86asm
;;; Sample lodsb
; Copy data from 1 array to another removing characters equal to 13 (Carriage Return in ASCII).
;;;

  ; Initialize registers
  lea rsi, [src]
  lea rdi, [dst]
  mov ecx, 1000000

more: 
  lodsb      ; Move 1 byte from rsi into al.
  cmp al, 13 ; 13 - al.
  je skip    ; If 13 - al results in 0, jump to "skip".

  ; Otherwise
  stosb      ; Move byte in al to address specified in rdi.
skip:
  sub ecx, 1 ; Manually decrement ecx (no rep instruction).
  jnz more   ; Go back to "more" if ecx is not zero.
```

#### Scan
- `scasb` searches array looking for a byte matching byte in al.
  - Uses rdi.
```x86asm
;;; Sample scasb
; C strlen implementation
;;;

strlen:
  cld          ; Clears Direction Flag (0 means INCREMENT rsi and rdi).
  mov rcx, -1  ; Max number of iterations
  xor al, al   ; 0 al register
  repne scasb  ; Repeat scan while it's not equal to al (this case 0).
  mov rax, -2  ; To start subtraction at -1
  sub rax, rcx ; Get the length. Store in rax as return.
  ret
```

#### Compare
- `cmpsb` compares values of 2 arrays.
- Used with `repe` which compare until ecx is 0 or two different values are located.
```x86asm
;;; Sample cmpsb
; C memcmp implementation
;;;

memcmp:
  mov rcx, rdx
  repe cmpsb              ; Compare until ecx is 0 or different value
  cmp rcx, 0              ; 0 - rcx
  jz equal                ; If 0, then memory is equal (reached the end; no differences).
  movzx eax, byte [rdi-1] ; Move with zeroes extended. -1 to prevent unneeded comparison.
  movzx ecx, byte [rsi-1] ; Move with zeroes extended. -1 to prevent unneeded comparison.
  sub rax, rcx            ; Use rax for return value (negative, zero, or positive).
  ret
equal:
  xor eax, eax ; Return 0
  ret
```

#### Set/Clear Direction
- `cld` unsets Direction Flag. 
  - Addresses will be auto-**increased** when using string operations.
- `std` sets Direction Flag.
  - Addresses will be auto-**decreased** when using string operations.
- Programmers should clear Direction Flag before exiting a function that sets it.