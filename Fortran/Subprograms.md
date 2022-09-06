<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 05
  Purpose: General Fortran (95/2003/2008) Subprogram Notes.
-->

# Subprograms
- Two types: *functions* and *subroutines*.
- Must be defined before use.

## Program Layout
- Either internal or external.
- Internal defined within the program (before "end program" statement).
```fortran
program name
  ...
contains
  <internal functions or subroutines>
end program name
  ! Can also be in seperate file
  <external functions or subroutines>
```

## Arguments
- Arguments in calling routine are referred to as *actual arguments*.
- Arguments in function or subroutine referred to as *formal arguments*.
  - Values passed from calling routine.
- Only way to transfer data in or out  of a subroutine.

### Intent
- *intent(in)*: information passed into function or subroutine.
- *intent(out)*: variable set by function or subroutine.
- *intent(inout)*: variable passed in, altered by function, then returned back.

## Variable Scope
- Variables defined in a subprogram not visible to the calling routine.

## User-Defined Functions
```fortran
<type> function <name> (<arguments>)
<declarations>

  <body of function>

  <name> = expression
  return
end function <name>


! Fahrenheit to Celcius
real function faToCe(ftemp)
real, intent(in) :: ftemp ! ftemp is declared real and intent(in)
                          ! intent(in): value coming in and cannot be changed

  faToCe = (ftemp - 32.0) / 1.8 ! This will be returned

  return
end function faToCe
```

- *Side-Effects*: when function changes one or more of its input arguments (intent(out) or intent(inout)).
  - **_Bad practice!_**

## Subroutines
- Fortran subprogram that can accept input information and return a result or series of results.
```fortran
subroutine <name> (<arguments>)
<declarations>
  
  <body of subroutine>

  return
end subroutine <name>


! Find sum of average
program sumavg
  
  implicit none

  real :: x1=4.0, y1=5.0, z1=6.0, sum1, avg1
  real :: x2=4.0, y2=5.0, z2=6.0, sum2, avg2

  call sumAvg(x1, y1, z1, sum1, avg1)
  write (*,'(a,f5.1,3x,a,f5.1)') "Sum=", sum1 &
                             "Average=", avg1

  call sumAvg(x2, y2, z2, sum2, avg2)
  write (*,'(a,f5.1,3x,a,f5.1)') "Sum=", sum2 &
                             "Average=", avg2

contains
  
  subroutine sumAvg (a, b, c, sm, av)
  real, intent(in)  :: a, b, c
  real, intent(out) :: sm, av

    sm = a + b + c
    av = sm / 3.0

    return
  end subroutine sumAvg

end program sumavg
```
- Functions return with a value, subroutine is a task and "return' only through arguments (intent(in|out|inout)).
