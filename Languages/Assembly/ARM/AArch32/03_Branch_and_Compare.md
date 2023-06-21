<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 18
  Purpose: Branch and compare notes for 32-bit ARM assembly
-->

# Branch and Compare
- `<Instruction> <Suffixes> <Label>`
- Physical limit is ±32MB.
- Absolute address is not stored; the offset from the current position is stored.
  - Value is a positive or negative adjustment to `PC` from current position.

## Branch Instructions
### B
- Commonly used with `AL` conditional suffix.
- Always jumps without preserving current address.
### BL
- Branch with Link
- Passes control to another part of the program (subroutine) and return on completion.
- Copies contents in `PC` (R15) into `LR` (R14) then branches.
- Return to caller with `MOV R15, R14`.
  - Preserves flags from before the return.
  - Overwrite and lose link addresses if a subroutine is called within a subroutine.
    - Overcome with stack utilization.
<!--
  TODO
    Review Thumb code first
-->
### BX
- `BX LR` jump out of a function.
### BLX
