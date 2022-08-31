<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 30
  Purpose: General Fortran (95/2003/2008) Notes.
-->

# General
- Often used in scientific and engineering computation.
- Means FORmula TRANslation.
- Comments denoted with `!`.
- File extensions either `.f95` (Fortran 95/2003/2008) or `.f90` (Fortran 90/modern).

# Format
- Program is started with `program <name>` and ended with `end program <name>`.
  - \<**name**\> may not be used again for other program elements.
  - Must start with a letter, followed by letters, numbers, or underscore and can't be longer than 32 characters.
  - Case-insensitive.

# Simple Output 
- `write` statement.
```fortran
program hello
  write(*,*) "Hello World"
end program first
```