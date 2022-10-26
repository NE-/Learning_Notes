<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 30
  Purpose: General Fortran (95/2003/2008) Variables Notes.
-->

# Variables
- Must be declared at start of the program.
- Names start with a letter, followed by letters, numbers, or underscore. 
  - Can't be longer than 32 characters.
  - Case insensitive.
- Fortran 95/2003/2008 allows implicit typing, however, it's bad practice and error-prone.
  - Use `implicit none` statement at the start of the program to turn off.

## Data Types
 | Type | Description |
 | ---- | ----------- |
 | integer | Whole number (positive, negative, or zero) |
 | real | Real number (fractions/floats) |
 | complex | Real and imaginary number |
 | character | Character or sequence of characters |
 | logical | Only be **.true.** or **.false.** |

### Integer
- Integer division, no rounding will occur.
- Assigning float to integer will cause precision loss.
  - Best to perform explicit conversions.

### Real
- Floating-point numbers.

### Character
- ASCII character or sequence of characters (string).

### Logical
- Can only have 2 values: `.true.` `.false.`.

## Declaring Variables
- `<type> :: <list of variable names>`
- Declarations placed in the beginning of the program (after program statement).

### Variable Ranges
- Integer: -2,147,483,648 to +2,147,483,647.
- Real: approx. ±1.7\*10<sup>±38</sup>.
  - About 7 digits of precision.

## Constants
- Use `parameter` qualifier.
```fortran
real, parameter :: pi = 3.14159
```

## Continuation Lines
- Use `&`.
```fortran
! Example of variables and formatting rules
program ex1
  
  implicit none

  real, parameter :: pi = 3.14159
  integer :: radius, diameter
  character(11) :: msg = "Hello World"

  write (*,*) "Program says: ", msg

end program ex1
```
## Extended Size Variables
- Integer use `kind` specifier to extend range.
```fortran
! Make integer 8 bytes versus usual 4 bytes
integer*8       :: bignum
! or
integer(kind=8) :: bignum
```
- Real use `kind` to extend precision.
```fortran
! Make real use 8 byte space versus usual 4 byte space
!! ~15 digits of precision
real*8       :: bigrnum
! or
real(kind=8) :: bigrnum
```
