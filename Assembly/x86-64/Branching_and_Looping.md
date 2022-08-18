<!--
  Author: NE- https://github.com/NE-
  Date: 2022 July 18
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
```asm
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

```asm
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

```asm
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

```asm
;;; Sample "while" loop

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