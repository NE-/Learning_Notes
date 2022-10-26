<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 31
  Purpose: General Fortran (95/2003/2008) I/O Notes.
-->

# Simple Input and Output
## Output
- `write(*,*)`.
  - First \* means default output device (screen monitor).
  - Second \* refers to *free format* (compiler determines appropriate format).
- Multiple variables using comma.
```fortran
write (*,*) "num1: ", num1, "num2: ", num2
```
- `print *`.
- Sends output *only* to the screen.
```fortran
print *,"num1: ", num1, "num2: ", num2
```

## Input
- `read (*,*)`.
  - First \* means STDIN (keyboard).
  - Second \* means *free format* (compiler determines format. Integer only(?)).
```fortran
read (*,*) num1, num2 ! read multiple variables
```
---
``` fortran
! Calculate area of a circle

program circle

  implicit none
  real :: rad, area
  real, parameter :: pi = 3.14159

  ! Write header
  write (*,*) "Circle Area Calculator"
  write (*,*)

  ! Calculate area
  area = pi * radius**2

  ! Display result
  write (*,*) "Area: ", area

end program circle
```
