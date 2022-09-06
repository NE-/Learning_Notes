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

# Intrinsic Functions
- Most common intrinsic functions.
## Conversion

 | Function | Description |
 | -------- | ----------- |
 | INT(A) | Returns integer value of real *A*, truncating towards 0. |
 | NINT(X) | Return nearest integer value (rounds up or down) of real *X*. |
 | REAL(A) | Returns real value of integer *A*.

## Integer Functions

  | Function | Description |
  | -------- | ----------- |
  | ABS(A) | Returns integer absolute value of integer *A*. |
  | MOD(R1,R2) | Returns integer remainder of integer argument *R1* divided by integer *R2*. |

## Real Functions

 | Function | Description |
 | -------- | ----------- |
 | ABS(A) | Returns the real absolute value of real argument *A*.
 | ACOS(W) | Returns the real inverse cosine of real argument *W* in radians. |
 | ASIN(W) | Returns the real inverse sine of real argument *W* in radians. |
 | ATAN(X) | Returns the real inverse tangent of real argument *X* in radians. |
 | COS(W) | Returns the real cosine of real argument *W* in radians. |
 | LOG(W) | Returns the real natural logarithm of real argument *W*. *W* must be positive. |
 | MOD(R1,R2) | Return the real remainder of real argument *R1* divided by real argument *R2*. |
 | SIN(W) | Returns the real sine of real argument *W* in radians. |
 | SQRT(W) | Returns the real square root of real argument *W*. *W* must be positive. |
 | TAN(X) | Returns the real tangent of real argument *X* in radians. |

## Character/String Functions

 | Function | Description |
 | -------- | ----------- |
 | ACHAR(I) | Returns the character represented by integer argument *I* based on the ASCII table. *I* must be between 1 and 127. |
 | IACHAR(C) | Returns the integer value of the character argument *C* represented by ASCII table. |
 | LEN(STR) | Returns the integer value representing the length of string argument *STR*. |
 | LEN_TRIM(STR) | Returns the integer value representing the length of string argument *STR* excluding any trailing spaces. |
 | LGE(STR1,STR2) | Returns the logical true, if *STR1* ≥ *STR2* and false otherwise. |
 | LGT(STR1,STR2) | Returns the logical true, if *STR1* > *STR2* and false otherwise. |
 | LLE(STR1,STR2) | Returns the logical true, if *STR1* ≤ *STR2* and false otherwise. |
 | LLT(STR1,STR2) | Returns the logical true, if *STR1* > *STR2* and false otherwise.
 | TRIM(STR) | Returns the string based on the string argument *STR* with any trailing spaces removed.
 | ADJUSTL(STR) | Return a string modified by removing leading spaces. Spaces are inserted at the end of the string as needed. |
 | ADJUSTR(STR) | Return a string modified by removing trailing spaces. Spaces are inserted at the beginning of the string as needed. |

## Complex Functions

 | Function | Description |
 | -------- | ----------- |
 | AIMAG(Z) | Returns the real value of the imaginary part of the complex argument *Z*. |
 | CMPLX(X,Y) | Returns the complex value with real argument *X* and the real part and real argument *Y* as the imaginary part. |
 | REAL(Z) | Returns the real value of the real part of the complex argument *Z*. |

## Array Functions

 | Function | Description |
 | -------- | ----------- |
 | MAXLOC(A1) | Returns the integer location or index of the maximum value in array *A1*. |
 | MAXVAL(A1) | Returns the maximum value in array *A1*. Type of value returned is based on the type of *A1*. |
 | MINLOC(A1) | Returns the integer location or index of the minimum value in array *A1*. |
 | MINVAL(A1) | Returns the minimum value in array *A1*. Type of value returned is based on the type of *A1*. |
 | SUM(A1) | Returns the sum of values in array *A1*. Type of value returned is based on the type of *A1*. |

## System Information Functions

 | Function | Description |
 | -------- | ----------- |
 | COMMAND_ARGUMENT_COUNT() | Returns the number of command line arguments. |
 | GET_COMMAND_ARGUMNENT(NUMBER,VALUE, LENGTH,STATUS) | Returns the command line arguments, if any.<br>- **NUMBER** integer argument of the number to return. Must be between 1 and COMMAND_ARGUMENT_COUNT().<br>- **VALUE** character(*), Nth argument.<br>- **LENGTH** integer, length of argument returned in **VALUE**.<br>- **STATUS** integer, status, 0=success and -1=**VALUE** character array is too small for argument, other values=retrieval failed |
 | CPU_TIME(TIME) | Returns the amount of CPU time expended on the current program in seconds. **TIME** is return as a real value. |
 | DATE_AND_TIME(DATE,TIME,ZONE,VALUES) | Return the date and time.<br>- **DATE**, character(8), string in the form YYYYMMDD<br>- **TIME**, character(10), string in the form HHMMSS.SSS.<br>- **ZONE**, character(5), string in the form of ±HHMM, where HHMM is the time difference between local time and Coordination Universal Time.<br>- **VALUES**, integer array where<br>VALUES(1) → year<br>VALUES(2) → month (1-12)<br>VALUES(3) → date (1-31)<br>VALUES(4) → time zone difference (minutes)<br>VALUES(5) → hour (0-23)<br>VALUES(6) → minutes<br>VALUES(7) → seconds (0-59)<br>VALUES(8) → milleseconds (0-999)<br>Each argument is optional, but at least one argument must be included. |
