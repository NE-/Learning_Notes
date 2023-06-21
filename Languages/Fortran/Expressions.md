<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 August 31
  Purpose: General Fortran (95/2003/2008) Expression Notes.
-->

# Expressions
## E-Notation
- Used to multiply constant/literal by 10 raised to the power following 'E' (scientific notation).
  - `2.75E5`, `3.333E-1`, `5.6789E4`
## Complex Literals
- First number is *real* second is *imaginary*.
  - `(2.3, -6.7)`, `(9.4, 3.3E-1)`, `(12, 94)`
    - Pairs are considered one value.
## Character Literals
- Case sensitive.
- Have quotes in string:
  - `"Good " "Morning " "John!"` displayed as `Good "Morning" John!`.

## Arithmetic Operations
- Assignment `=`
- Addition `+`
- Subtraction `-`
- Multiplication `*`
- Division `/`
- Exponentation `**`
  - Raising integers to power of floating point will truncate result.
### Order of Operations
 | Precedence Level | Operator | Operation |
 | ---------------- | -------- | --------- |
 | 1<sup>st</sup> | - | unary - |
 | 2<sup>nd</sup> | ** | exponentation |
 | 3<sup>rd</sup> | * / | Multiplication and Division |
 | 4<sup>th</sup> | + - | addition and Subtraction |
- Same precedence level evaluated from left-to-right.
- Parenthesis can change order of evaluation.

## Intrinsic Functions
> **Short incomplete list. For introduction only!**
- cos(\<real>)
  - Returns radians.
- sin(\<real>)
  - Returns radians.
- tan(\<real>)
  - Returns radians.
- mod(\<integer | real>, \<integer | real>)
- sqrt(\<real>)
  - Argument must be positive.
> Conversion Functions
- int(\<real>)
  - Truncates *real* part towards zero.
- real(\<integer>)
- nint(\<real>)
  - Returns nearest integer to real value \<real>.
    - Rounds up or down.

## Mixed Mode
- **Recommended not to use!** Unexpected conversions can cause problems.
- Integers and real numbers used in the same statement.
- Integers converted to real on same operation type.
  - Also may convert on assignment.
- Conversion: Weaker of two types is promoted to stronger type.
  - Weaker is one with less precision or fewer storage units

 | Data Type | Rank |
 | --------- | ---- |
 | BYTE or LOGICAL\*1 | 1 (weakest) |
 | LOGICAL\*2 | 2 |
 | LOGICAL\*4 | 3 |
 | INTEGER\*2 | 4 |
 | INTEGER\*4 | 5 |
 | INTEGER\*8 or LOGICAL\*8 or REAL\*4 | 6 |
 | REAL\*8 (DOUBLE PRECISION) | 7 |
 | REAL\*16 (QUAD PRECISION)(SPARC only) | 8 |
 | COMPLEX\*8 | 9 |
 | COMPLEX\*16 (DOUBLE COMPLEX) | 10 |
 | COMPLEX\*32 (QUAD COMPLEX) (SPARC only) | 11 (strongest) |

### Rules
- If more than one operator, type of last operation performed becomes type of final value.
- Integer operators apply only to integer operands.
  - 2/3 + 3/4 evaluates to 0.
- INTEGER\*8 mixed with REAL\*4 result is REAL*8.
  - Logical and byte operands in arithmetic context used as Integer.
- Real operators apply only to Real operands, or combination of byte, logical, integer, and real operands.
  - Integer mixed with Real promoted to Real. Fraction is 0.
    - (2/3)*4 is 0.
- Double precision operators apply only to double precision operands, and any operand of lower precision is promoted to double.
  - New least significant bits of new number set to 0.
  - Promoting Real operand doesn't increase accuracy of operand.
- Complex operators apply only to complex operands. Integer operands promoted to real (imaginary part set to 0).
- Numeric operations allowed on logical variables.
  - Numreic can be: integer, real, complex, double precision, double complex, or real\*16 (SPARC only).
  - Compiler implicitly converts logical to appropriate numeric.
  - **Using these features may make your program not portable!**
---

```fortran
! Calculate velocity from acceleration and time

program findvelo

  implicit none
  
  real :: velo, accel = 128.0
  real :: time = 8.0

  ! Display header
  write (*,*) "Velocity Calculator"
  write (*,*)

  ! Calculate velocity
  velo = accel * time

  write (*,*) "velocity = ", velocity

end program findvelo
```
