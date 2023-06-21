<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 02
  Purpose: General Fortran (95/2003/2008) IO Format Notes.
-->

# Formatted Input/Output
```fortran
read  (*, '<format specifiers>') <variables>
write (*, '<format specifiers>') <variables/expressions>
```
## Format Specifiers
- *w* - number of positions to be used.
- *m* - minimum number of positions to be used.
- *d* - number of digits to right of decimal point.
- *n* - number or count.
- *c* - column number.
- *r* - repeat count.

 | Description | Specifier |
 | ----------- | --------- |
 | Integers | rIw or rIw.m |
 | Real | rFw.d |
 | Logicals | rLw |
 | Characters | rA or rAw |
 | Horizontal Positioning (space) | nX |
 | Horizontal Positioning (column) | Tc |
 | Vertical Spacing | n/ |

## Integer Format Specifier
- `rIw rIw.m`.
  - *w* - width or how many total places are used. Negative sign counts as one place.
  - *m* - set minimum number of digits to display. Leading zeros displayed if needed.
  - *r* - number of times format specifier should be repeated.
```fortran
! (i6)
1 2 3 4 5 6

! (i2,i3) 12, 123
12123

!(i2,i4) 12, 123
! Space because print 4-wide on a 3-wide integer
12 123
```

## Real Format Specifier
- `rFw.d`
  - *w* - width or how many total places are used, including decimal point.
    - Negative sign counts as one space.
  - *d* - digits displayed after decimal point.
  - *r* - number of times the format specifier should be repeated.
```fortran
! (f6.2)
1 2 3 . 4 5

! (f3.1) 4,5
4.5 ! No leading spaces

! (f5.2,f8.3) 4.5, 12.0
 4.50  12.000
```

## Horizontal Positioning Specifiers
- `nX Tc`
  - *n* - number of spaces to insert.
  - *c* - column number to move to.
```fortran
! (a,2x,a,t20,a) "X", "Y", "Z"
X  Y               Z
```
## Logical Format Specifier
- `rLw`
  - *w* - width or how many total places are used.
  - *r* - number of times format specifier is repeated.
```fortran
! (l1,1x,l1) varTrue, varFalse
T F

! (l3,2x,l3) varTrue, varFalse
  T    F
```

## Character Format Specifier
- `rAw`
  - *w* - width or how many total places are used.
    - If no width specified, existing length of string is used.
  - *r* - number of times format specifier is repeated.
```fortran
! (a6)
c c c c c c

! (a11) "Hello World"
Hello World

! (a) "Hello World"
! width omitted
Hello World

! (a9) "Hello World"
Hello Wor
```

## Advance Clause
- Tells computer whether or not to advance cursor to next line.
  - Values are `"yes"` and `"no"`. `"yes"` is default.
```fortran
write (*,(a), advance="no") "Enter count: "
read (*,*) n
```
