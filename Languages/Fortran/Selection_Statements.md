<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 01
  Purpose: General Fortran (95/2003/2008) Selection Statements.
-->

# Selection Statements
- Change flow of program depending on the outcome of variable comparisons.
## Condition Expressions
- Relational operators used between **matching types**.
- Higher precedence than logical operators.

 | Operation | Operator | Operator (alternative) |
 | --------- | -------- | ---------------------- |
 | Greater Than | \> | .gt. |
 | Greater Than or Equal | \>= | .ge. |
 | Less Than | \< | .lt. |
 | Equal To | == | .eq. |
 | Not Equal To | \/= | .ne |

> Alternative forms may be required to support older Fortran programs.

## Logical Operators
- Used between logical operators or two conditional expressions.

 | Operator | Explanation |
 | -------- | ----------- |
 | .and. | true if **_both_** operands are true |
 | .or. | true if **_either_** operand is true |
 | .not. | true made false, false made true |

## IF Statements
```fortran
if ( <conditional expression>) then
  ...
end if
```
### Simple Form
```fortran
! Only a single statement
if (<conditional statement>) <fortran statement>
```

### IF THEN ELSE
```fortran
if (<conditional expression>) then
  ...
else
  ...
end if
```
### IF THEN ELSE IF
```fortran
if (<conditional expression>) then
  ...
else if (<conditional expression>) then
  ...
else
  ...
end if
```
---
```fortran
! Example quadratic equation solver
program quadratic

  implicit none
  real :: a, b, c
  real :: discriminant, root1, root2

  ! Write header and prompt
  write (*,*) "Quadratic Equation Calculator"
  write (*,*) "Enter A, B, and C values"

  ! Get user input
  read (*,*) a, b, c

  ! Calculate discriminant
  discriminant = b ** 2 - 4.0 * a * c

  ! If discriminant is 0, one root only
  if (discriminant == 0) then
    ! calculate and display root
    root1 = -b / (2.0 * a)
    write (*,*) "One root: ", root1
  end if

  ! If discriminant > 0 have two roots
  if (discriminant > 0) then
    root1 = (-b + sqrt(discriminant)) / (2.0 * a)
    root2 = (-b - sqrt(discriminant)) / (2.0 * a)

    write (*,*) "Real roots: ", root1, " ", root2
  end if

  ! If discriminant < 0 2 complex roots
  if (discriminant < 0) then
    root1 = -b / (2.0 * a)
    root2 = sqrt(abs(discriminant)) / 2.0 * a

    write (*,*) "Complex roots:"
    write (*,*) "root1: ", root1, "+i", root2
    write (*,*) "root2: ", root1, "+i", root2
  end if

end program quadratic
```
---

## SELECT CASE statement
- Compare value against preselected constants and take action upon first constant match.
- Variable or expression must be integer, character, or logical (no real types allowed).
```fortran
select case (variable)
  case (selector-1)
    ...
  case (selector-2)
    ...
  case (selector-n)
    ...
  case default ! Optional
    ...
end select
```
- Selector lists may contain a list or range of integers, characters, or logical constants, whose values may not overlap with or between selectors.
  - Lists of values are seperated by commas.
  - Ranges use colon. `(a:b)` where a is start value and b is end value (inclusive).
    - a must be less than b.
```fortran
(value)           ! single value
(value1 : value2) ! values in range value1 and value2 (inclusive)
(value : )        ! All values greater-than or equal-to value
( : value)        ! All values less-than or equal-to value
```
- *If result was not found in any selector, _case default_ block is executed. If no default, then he statement following _end select_ is executed.*
- *Constants in selectors must be unique.*
