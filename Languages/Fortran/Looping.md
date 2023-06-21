<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 02
  Purpose: General Fortran (95/2003/2008) Looping.
-->

# Looping
- **_do-loop_** is a controlled statement that allows for multiple execution of statements.

## Counter Controlled
- Repeat statements a set number of times.
```fortran
do count_variable = start, stop, step
  ...
end do
```
- **count_variable** must be integer.
- **start stop step** integer or integer expression.
  - **step** is optional. Omitted makes step = 1. **step** can't be 0.

## EXIT and CYCLE
- `exit` used to exit a loop (counter or conditionally controlled).
- `cycle` skips the remaining portion of do-loop and start back at the top. Counter or conditionally controlled loops.
  - The next index counter updated to next iteration.

## Conditional Controlled
- Repeats statements an indeterminate number of times (until a condition is met).
```fortran
! Condition is re-evaluated on each iteration
do while (conditional expression)
  ...
end do

! Use multiple conditions if necessary
do
  ...
  if (conditional expression) exit
  ...
  if (conditional expression) exit
  ...
end do
```
```fortran
! Prompt until correct input
do
  write (*,*) "Enter month (1-12): "
  read (*,*) month
  if (month >= 1 .and. month <= 12) exit
  write (*,*) "Error: month must be between 1 and 12."
end do
```
