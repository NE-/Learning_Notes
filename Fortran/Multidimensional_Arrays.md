<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 05
  Purpose: General Fortran (95/2003/2008) Multidimension Arrays Notes.
-->

# Multidimensional Arrays
- Element access `array(1,2)` `array(2,3) = 9`
## Array Declartion
### Static Declaration
```fortran
<type>, dimension(<extent>,<extent>) :: name

integer, dimension(100, 100) :: arr
```
- *extent* can be specified as *(smaller-integer:larger-integer, smaller-integer:larger-integer)*.
```fortran
! indexes between 0 and 9 inclusive
integer, dimension(0:9,0:9) :: arr
```

### Dynamic Declaration
```fortran
integer, dimension(:,:), allocatable :: arr

! Allocation
allocate(<array name>, <dimension>, stat=<status variable>)

! EXAMPLE
integer, dimension(:,:), allocatable :: nums
integer :: allstat

allocate(nums(100,100), stat=allstat)
```

```fortran
! Example Monte Carlo Pi estimation

program piestimation

  implicit none

  integer :: count, alstat, i, incount
  real :: x, y, pi_est, pt
  real, allocatable, dimension(:,:) :: points

  ! Display header
  write (*,'(/a/)') "PI Estimation"

  do
    ! Prompt for count value
    write (*,'(a)',advance="no") "Enter count (100 - 1,000,000): "
    read (*,*) count

    ! If in bounds, exit loop
    if (count >= 100 .and. count <= 1000000) exit

    ! Otherwise, display error message
    write (*,'(a,a,/a)') "Error, count must be between ", &
                         "100 and 1,000,000.",            &
                         "Please re-enter."
  end do

  ! Allocate 2d array
  allocate (points(count,2), stat=alstat)
  ! Allocation failed
  if (alstat /= 0) then
    write (*,'(a,a,/a)') "Error, unable to", &
      "allocate memory, terminating..."
    stop
  end if

  ! Generate points
  call random_seed()

  do i=1, count
    call random_number(x)
    call random_number(y)

    pts(i,1) = x
    pts(i,2) = y
  end do

  ! Monte Carlo estimation
  incount = 0 ! sample count in circle

  do i=1, count
    pt = pts(i,1)**2 + pts(i,2)**2
    if (sqrt(pt) < 1.0) incount = incount + 1
  end do

  pi_est = 4.0 * real(incount) / real(count)

  ! Display results
  write (*,'(a, f8.2)') "Count of points: ", count
  write (*,'(a, f8.2)') "Estimated pi values: ", pi_est

end program piestimation
```
