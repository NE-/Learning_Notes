<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 05
  Purpose: General Fortran (95/2003/2008) Recursion Notes.
-->

# Recursion
## Subroutines
```fortran
recursive subroutine <name> (<arguments>)
<declarations>

  <body of subroutine>

  return
end subroutine <name>
```

```fortran
! Example print decimal number in binary

program binary
  implicit none
  integer :: decNum

  ! Display header
  write (*,'(a/)') "Decimal to Binary Converter"

  do
    ! Prompt for decimal number
    write (*,'(a)', advance="no") &
      "Enter decimal number (0 - 1,000,000): "
    read (*,*) decNum

    ! Check if input in range
    if (decNum >= 0 .and. decNum <= 1000000) exit

    write (*,'(a)') "Error, decimal out of range."
    write (*,'(a)') "Please re-enter."
  end do

  write (*,'(/a,i7,a)', advance="no") decNum, " is "

  call printBinary(decNum)
  write (*,'(/)')

contains
  
  recursive subroutine printBinary(num)
  integer, intent(in) :: num

    if (num > 1) call printBinary(num/2)

    write (*,'(i1)',advance="no") mod(num,2)

    return
  end subroutine printBinary
end program binary
```

## Functions
```fortran
<type> recrsive function <name> (<args>) result (<variable>)
  <body of function>

  <variable> = expression

  return
end function <name>
```
- `result` specifies a single variable for the return value.
```fortran
! Example factorial
program factorial

  implicit none

  integer :: num, numFact

  ! Display header
  write (*,'(a/)') "Recursion Example"

  do
    ! Prompt for factorial term
    write (*,'(a)',advance="no") "Enter N (1-15): "
    read (*,*) num

    ! Check if input is in range
    if (num >= 1 .and. num <= 15) exit

    ! Error detected
    write (*,'(a)') "Error N out of range (1-15)."
    write (*,'(a)') "Please re-enter."
  end do

  ! Get factorial
  numFact = fact(num)

  ! Print result
  write (*,'(a,i2,a,i10,/)') "Factorial of ", num, " is ", numFact

contains
  
  integer recursive function fact(n) result (ans)
    implicit none
    integer, intent(in) :: n

    if (n == 1) then
      ans = 1
    else
      ans = n * fact(n-1)
    end if

    return
  end function fact

end program factorial
```
