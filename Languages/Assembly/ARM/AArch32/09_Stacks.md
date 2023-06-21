<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 19
  Purpose: Stack notes for 32-bit ARM assembly
-->

# Stacks
- Areas of memory the programmer defines.
- No limit to number of stacks, except physical memory available.
- `STM` push, `LDM` pull.
- R13 general Stack Pointer, but can use any register(s) for this purpose.
- `PUSH` and `POP` are aliases for *Simple stack 1*.
  - Using with lists is *Simple stack 2*.
```arm
/* Simple stack 1 */
STR R0, [SP, #-4]! @ Push
LDR R0, [SP], #4   @ Pop

/* Simple stack 2 */
STMIA SP!, {R0-R12, LR} @ Push registers onto stack
LDMDB SP!, {R0-R12, PC} @ Pull registers from stack
```
- `IA` move up through memory to push.
- `DB` move down through memory to pull.
- `LR` and `PC` used to save the program counter's address.
  - Useful for saving register contents before subroutine call.
- `!` updates the stack pointer.
  - ***Extremely important for this particular use!***
  - Not using it will not update the stack pointer and corrupt the stack.
- Can use a base pointer (static; never changing) *and* stack pointer.

## Stack Growth
- Programmer decides if stack ascends or descends.
- `FA` Full Ascending stack
- `FD` Full Descending stack (default)
- `EA` Empty Ascending stack
- `ED` Empty Descending stack
- `F`ull: stack pointer points to last occupied address on stack.
- `E`mpty: stack pointer indicates next available free space on stack.
- Use with `STM` and `LDM`
```arm
/*
  Ascending Stacks
 */
STMFA SP!, {R0-R4}
R4 <<SP
R3
R2
R1
R0
   <<Old SP
////////////////////
STMEA SP!, {R0-R4}
   <<SP
R4
R3
R2
R1
R0 <<Old SP

/*
  Descending stacks
 */
STMFD SP!, {R0-R4}
   <<Old SP
R4
R3
R2
R1
R0 <<SP
////////////////////
STMED SP!, {R0-R4} 
R4 <<Old SP
R3
R2
R1
R0
   <<SP
```

## Useful Applications
- Saving register contents.
- Saving and processing data.
- Save and restore link addresses when subroutines are called.
  - Allow for returning from nested routines.
- Swap register contents.
```arm
/* Multiple register swap */
/*
  Src    Dst
  R0     R3
  R1     R4
  R2     R6
  R3     R5
  R4     R0
  R5     R1
  R6     R2
 */
STMFD SP!, {R0-R6}      @ Push R0-R6 onto stack
LDMFD SP!, {R3, R4, R6} @ Load R0-R2 to R3, R4, R6 respectively
LDMFD SP!, {R5}         @ Load R3 to R5
LDMFD SP!, {R0, R1, R2} @ Load R4-R6 to R0, R1, R2 respectively
```