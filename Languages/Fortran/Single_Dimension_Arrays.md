<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 05
  Purpose: General Fortran (95/2003/2008) Single Dimension Arrays Notes.
-->

# Single Dimension Arrays
- Index (subscript) starts at '1'.
- Element access uses parentheses e.g. `array(2)` `array(3)=42`.
- Bound check with *gfortran* compiler flag `-fcheck=bounds`.
  - Bounds checking can slow down programs!

## Static Declaration
```fortran
<type>, dimension(<extent>) :: name

integer, dimension(100) :: arr
```
- *extent* can be changed using *smaller-integer : larger-integer*.
  - When *smaller-integer* is omitted, it is assumed to be '1'.
```fortran
! Indexes are -5 to 5 inclusive
integer, dimension(-5:5) :: ranges
```
### Initialization
```fortran
real, dimension(4) :: prices=(/10.0, 15.0, 20.0, 25.0/)
integer, dimension(4) :: nils=0 ! All elements are set to 0

! Set all elements to 0 after declaration
prices = 0.0
```
- `/` assigns numbers in order.

## Dynamic Declaration
```fortran
! No reserved space for values
integer, dimension(:), allocatable :: arr
```
- Dynamic arrays must be declared allocatable.
```fortran
allocate(<array name>, stat=<status variable>)
```
- `stat` is used for indicating success or failure of operation.
  - 0 means success, > 0 means allocation failure.
```fortran
integer, dimension(:), allocatable :: arr
integer :: allstat

! Size can be variable, but must be an integer
allocate(arr(100), stat=allstat)
```

## Implied Do-Loop
```fortran
! Initialization
integer, dimension(5) :: nums = (/ (i, i=1,5) /)

write (*,*) (nums(i), i=1,5)
```
## Intrinsic Functions
 | Function | Description |
 | -------- | ----------- |
 | MAXVAL(ARR) | Returns max value in array ARR. |
 | MINVAL(ARR) | Returns min value of array ARR. |
 | SUM(ARR) | Returns sum of values in array ARR. |
 ---

 ```fortran
 ! Example standard deviation

 program stddev

  implicit none

  integer :: i, ncount=0, errs=0, opstat, rdstat
  real :: num, min, max, sum, average, stdsum, std
  real, dimension(5000) :: numbers
  character(20) :: filename

  ! Display header
  write (*,*) "Standard Deviation Program"

  do
    ! prompt for file name
    write (*, '(a)', advance="no") "Enter file name: "
    read (*,*) filename

    ! open file
    open(42, file=filename, status="old,   &
         action="read", position="rewind", &
         iostat=opstat
    )
    ! If file open successful, exit prompt loop
    if (opstat==0) exit

    ! Display error message
    write (*, '(a)') "Error, can not open file!"
    write (*, '(a)') "Please re-enter"

    ! count error
    errs = erss + 1
    ! 3 chances to enter filename
    if (errs > 3) then
      write (*,'(a)') "Too many failed attempts."
      write (*,'(a)') "Terminating..."
      stop
    end if
  end do

  do
    ! read file
    read (42, *, iostat=rdstat) num
    if (rdstat>0) stop "Reading error"

    ! EOF exit loop
    if (rdstat<0) exit

    ! Increment number counter
    ncount = ncount + 1

    ! Store number in array
    numbers(ncount) = num
  end do

  do i = 1, ncount
    ! check for new min and max
    if (numbers(i) < min) min = numbers(i)
    if (numbers(i) > max) max = numbers(i)

    sum = sum + numbers(i)
  end do

  ! calculate average
  average = sum / real(ncount)

  ! initialize stdsum
  stdsum = 0.0

  do i=1, ncount
    ! (average-array item)^2
    stdsum = stdsum + (average - numbers) ** 2
  end do

  ! calculate standard deviation
  std = sqrt(stdsum / (real(ncount) - 1))

  ! display results
  write (*,'(a)') "-------------------------------"
  write (*,'(a)') "Results:"

  do i=1, ncount
    write (*,'(f8.2,2x)', advance="no") numbers(i)
    if (mod(i,10)==0) write (*,*) ! line format
  end do

  write (*,'(a, f8.2)') "Minimum = ", min
  write (*,'(a, f8.2)') "Maximum = ", max
  write (*,'(a, f8.2)') "Sum = ", sum
  write (*,'(a, f8.2)') "Average = ", average
  write (*,'(a, f8.2)') "Standard Deviation = ", std

end program stddev
```
