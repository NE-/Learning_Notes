<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 02
  Purpose: General Fortran (95/2003/2008) Characters and Strings Notes.
-->

# Characters and Strings
- Quote inside string must have double-double quotes (sometimes referred to as an "escape character").
```fortran
"Quotes ""inside"" a string!"
```

## Variable Declaration
- Character variables must have a defined length for setting aside memory.
  - If length is omitted, default length is 1.
  - If string length is longer than assigned string, it will be right-padded with blanks.
```fortran
character(len=9) :: dayofweek
character(len=4) :: abbrvMonth="Jan."

! Let Fortran compiler set the length
character(len=*) :: lang="English"

! len= can be omitted
character(30) :: username

! ERROR: can't have multiple lengths in one declaration
character(len=12, len=1) :: name, gender
```

## Concatenation
- `//` concatenates two strings together.
```fortran
"University of " // "Kansas"
```
- Characters, variables, and literals can be used with concatenation.
```fortran
character(len=6)  :: str1="ABCDEF", str2="123456"
character(len=12) :: str3

str3 = str1 // str2 ! str3 set to "ABCDEF123456"
```


## Substrings
- `(start:stop)` where *start* is starting position and *stop* is ending position.
  - stop must be greater than start.
  - 1-indexed (first char position is 1).
```fortran
character(len=6) :: str1="ABCDEF", str2="123456", str3

str3 = str1(1:3) // str2(4:6)
```

## Character Comparisons
- Standard relational operators work.
- Character's "value" based on their location in the ASCII table (upper-case letters less than lower-case. Digits are less than letters).

## Intrinsic Character Operations
- **Incomplete list; just an introduction**.

 | Function | Description |
 | -------- | ----------- |
 | ACHAR(I) | Returns character representation of *I* based on ASCII table. *I* must be between 1 and 127. |
 | IACHAR(C) | Returns integer value of characher argument *C* represented by ASCII table. |
 | LEN(STR) | Returns integer representing length of string *STR*. |
 | LEN_TRIM(STR) | Returns integer value representing length of string *STR* excluding trailing spaces. |
 | TRIM(STR) | Returns string based on *STR* with trailing spaces removed. |
 | ADJUSTL(STR) | Return string modified by removing leading spaces. Spaces inserted at end as needed. |
 | ADJUSTR(STR) | Return string modified by removing trailing spaces. Spaces inserted at beginning as needed. |
---

```fortran
! Convert lower-case letters to upper-case letters
program convCase

  implicit none

  integer :: i, strlen
  character(80) :: str1

  ! Display header
  write (*,'(a,/)') "Case Converter"

  ! Prompt for string
  write (*,'(a)', advance="no") "Enter string (80 char max): "
  read (*,'(a)') str1

  ! Trim trailing blanks and get length
  strlen = len(trim(str1))

  ! for each character in string str1
  do i=1, strlen
    ! If lowercase found
    if (str1(i:i) >= "a" .and. str1(i:i) <= "z") then
      ! Convert to uppercase
      str1(i:i) = achar(iachar(string(i:i)) - 32)
    end if
  end do

  ! Display result
  write (*,'(/,a)') "-------------------------------------"
  write (*,'(a,/,2x,a,/)') "Final String: ", str1



end program convCase
```

## String to Numeric Conversions
- Done with internal `read` operation.
```fortran
! Example character to numeric conversion using read

program convert

  implicit none

  integer :: cvtErr
  character(4) :: iString   = "1234"
  character(4) :: rString   = "3.14159"
  character(4) :: badString = "3.14z59"
  integer :: iNum1, iNum2
  real :: pi, tau

  ! Display header
  write (*,'(a, /)') "Character to Numeric Conversion"

  ! Convert string to integer
  read (iString, '(i10)', iostat=cvtErr) iNum1

  ! Check read status
  if (cvtErr == 0) then
    ! Successful operation
    iNum2 = iNum1 * 2
    write (*,'(a, i5, /, a, 15, /)') &
      "num1 = ", iNum1, "num2 = ", iNum2
  else
    write (*,'(a,/)') "Error, invalid integer string."
  end if

  ! Convert string to real
  ! Not reading from STDIN; using variable instead
  read (rString, '(f17.6)', iostat=cvtErr) pi

  ! Check read status
  if (cvtErr == 0) then
    tau = pi * 2.0
    write (*,'(a,f5.3,/,a,f5.3,/)') &
      "pi = ", pi, "tau = ", tau
  else
    write (*,'(a,/)') "Error, invalid real string"
  end if

  ! Convert string to real
  !! Demonstrate error handling
  read (badString, '(f12.4)', iostat=cvtErr) pi

  ! Check read status
  if (cvtErr == 0) then
    tau = pi * 2.0
    write (*,'(a,f5.3,/,a,f6.3,/)') &
      "pi = ", pi, "tau = ", tau
  else
    write (*,'(a,/)') "Error, invalid real string"
  end if

end program convert
```

## Numeric to String Conversion
- Done with internal `write` operation.
```fortran
! Example convert integer/real to string
program convert

  implicit none

  integer :: cvtErr
  character(50) :: str1, str2, msg1, msg2
  integer :: iNum = 2468
  real :: pi=3.14, tau

  ! Display header
  write (*,'(a,/)') "Numeric to String Conversion"

  ! Convert integer to string
  iNum = iNum / 100
  ! Not writing to STDOUT; using variable instead
  write (str1, '(i3)', iostat=cvtErr) iNum

  if (cvtErr == 0) then
    msg1 = "My age is " // str1
    write (*,'(a,a)') "Message 1 = ", msg1
  else
    write (*,'(a,/)') "Error, invalid conversion"
  end if

  ! Convert real to string
  tau = pi * 2.0
  write (str2, '(f5.3)',iostat=cvtErr) tau

  if (cvtErr==0) then
    msg2 = "TAU is " // str2
    write (*,'(a,a,/)') "Message 2 = ", msg2
  else
    write (*,'(a,/)') "Error, invalid conversion"
  end if

end program convert
```
