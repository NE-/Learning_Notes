<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 06
  Purpose: General Fortran (95/2003/2008) System Services Notes.
-->

# System Services
- "Asking OS for information".
  - `read`, `write`, and `file` operations are system services.

## Date and Time
- ~~`get_date_time()`~~ *This function was in a book, but not found elsewhere. Book says this is the system service call*.
- `date_and_time()`

 | Option | Data Type | Description |
 | ------ | --------- | ----------- |
 | date | character(8) | String returned. Format YYYMMDD |
 | time | character(10) | String returned. Format HHMMSS.SSS |
 | zone | character(5) | String returned. Format ±HHMM (difference between local and Coordination Universal Time) |
 | values | integer array (8 elements) | values(1) -> year<br>values(2) -> month (1-12)<br>values(3) -> date (1-31)<br>values(4) -> time zone difference (minutes)<br>values(5) -> hour (0-23)<br>values(6) -> minutes (0-59)<br>values(7) -> seconds (0-59)<br>values(8) -> milliseconds (0-999) |
- Each argument is optional, but at least one argument must be included
```fortran
! Example obtain date and time information from system

program datetime
  implicit none

  integer, dimension(8) :: valuesArr
  character(len=8) :: today
  character(len=10) :: now
  character(len=5) :: myzone
  integer :: i

  ! Display header
  write (*, '(a)') "Example Date and Time Functions"

  ! Get date, time, and zone
  call date_and_time(date=today)
  write (*,'(/a,a)') "Today is ", today

  call date_and_time(time=now, zone=myzone)
  write (*,'(a,a)') "Time is ", now
  write (*,'(a,a/)') "Time Zone is ", myzone

  ! Get integer date values
  call date_and_time(values=valuesArr)

  write (*,'(a)') "Values Array:"

  write (*,'(a, i4)') "Date, Year:        ", valuesArr(1)
  write (*,'(a, i2)') "Date, Month:       ", valuesArr(2)
  write (*,'(a, i2)') "Date, Day:         ", valuesArr(3)
  write (*,'(a, i2)') "Time, Hour:        ", valuesArr(5)
  write (*,'(a, i2)') "Time, Minutes:     ", valuesArr(6)
  write (*,'(a, i2)') "Time, Seconds:     ", valuesArr(7)
  write (*,'(a, i3)') "Time, Millseconds: ", valuesArr(8)

  write (*,'(/,a, i8)') "Time difference with UTC in minutes: ", &
    valuesArr(4)

  write (*,'(a, i2, a1, i2.2 ,/)') 
    "Time difference with UTC in hours: ",      &
    valuesArr(4)/60, ":", mod(valuesArr(4), 60)

end program datetime
```

## Command Line Arguments
- `command_argument_count()` returns argument count. 0 if none entered.
```fortran
integer :: argc
argc = command_argument_count()
```
- `get_command_argument()` returns entered aruments as strings.
  - If character variable is too small, returned result is truncated and the status is set accordingly to indicate an error.
 
 | Option | Data Type | Description |
 | ------ | --------- | ----------- |
 | length | integer | Input integer argument indicating which argument should be returned. Must be between 1 and the `command_argument_count()` value |
 | value | character(*) | Output character variable of where to store N<sup>th</sup> argument as specified by **length**(in) value. |
 | length | integer | Output integer argument for the actual length of the string returned by **value**. |
 | status | integer | Output integer for returned status value. 0 = success, -1 = failure. |

```fortran
! Example obtaining command line arguments

program argsEx
  implicit none

  integer :: argN, allocStat, rdErr, i, iNum
  real :: rNum
  character(len=80), dimension(:), allocatable :: args

  ! Get CLA count
  argN = command_argument_count()

  if (argN == 0) then
    write (*,'(a)') "No command line arguments provided."
    stop
  end if

  ! Allocate memory to hold arguments
  allocate(args(argN), stat=allocStat)

  if (allocStat > 0) then
    write (*,'(a)') "Allocation error. Terminating..."
    stop
  end if

  ! Get each argument
  do i = 1, argN
    call get_command_argument(number=i,value=args(i))
  end do

  ! Display arguments
  if (argN == 0) then
    write (*,'(a)') "No command line arguments provided."
  else
    if (argN == 1) then
      write (*,'(a, i1, a)') "There was ", argCount, " command line argument."
    else
      write (*,'(a, i2, a)') "There were ", argCount, " command line arguments."
    end if

    write (*,'(/,a)') "The arguments were: "
    do i = 1, argN
      write (*,'(a,a)') "  ", trim(args(i))
    end do

    write (*,*)
  end if

  ! Convert string to numeric
  if (argN >= 1) then
    read(args(1), '(f12.5)',iostat=rdErr) rNum

    if (rdErr == 0) then
      write (*,'(a,f12.5)') &
        "Argument 1 - Real Number = ", rNum
    else
      write (*,'(a)') "Error, invalid real value."
    end if
  end if

  if (argN >= 2) then
    read(args(2), '(i10)',iostat=rdErr) iNum

    if (rdErr == 0) then
      write (*,'(a,i10)') &
        "Argument 2 - Integer Number = ", iNum
    else
      write (*,'(a)') "Error, invalid integer value."
    end if
  end if

  write (*,*)

end program argsEx
```

## Random Number Generation
- `random_seed()` initializes random number generator. 
  - No arguments uses seed from random data retrieved from the OS (based on date and time).
  - Can only be perfored once.

 | Option | Data Type | Description |
 | ------ | --------- | ----------- |
 | size | integer | Specifies minimum size of arrays used with **put** and **get**. |
 | put | integer array | Resets value of seed. Must be >= **size**. |
 | get | integer array | Returns current value of seed. Must be >= **size**. |

- `random_number()` requests a random number in range 0.0 <=random_number < 1.0.
  - Larger numbers can be obtained by multiplying by a scalar.

 | Option | Data Type | Description |
 | ------ | --------- | ----------- |
 | harvest | real or real array | Returns generated random number. |

```fortran
! Example generate 100 random numbers

program rand
  
  implicit none

  integer, parameter :: rcount=100
  integer :: i
  integer, dimension(rcount) :: nums
  real :: x

  call random_seed()

  ! Get random numbers
  do i = 1, rcount
    call random_number(x)
    nums(i) = int(x*100.0) + 1
  end do

  ! Display random numbers
  write (*,'(a)') "Random Numbers: "

  do i = 1, rcount
    write (*,'(i3,2x)',advance="no") nums(i)
    if (mod(i,10)==0) write (*,*)
  end do
end program rand
```

```fortran
! Example dice roll

program diceroll
  implicit none

  integer :: m, d1, d2, pair
  real :: x
  integer :: i, n, clock
  integer, dimension(:), allocatable :: seed
  character(10) :: nickname

  call random_seed(size=n)
  allocate(seed(n))

  call system_clock(count=clock)
  seed = clock + 37 * (/(i-1, i=1, n)/)

  call random_seed(put=seed)
  deallocate(seed)

  call random_number(x)
  d1 = int(x*6.0) + 1

  call random_number(x)
  d2 = int(x*6.0) + 1

  write (*,(2(a,1x,i1/),a,1x,i2)') "Dice 1: ", d1, &
    "Dice 2: ", d2, "Dice Sum: ", (d1+d2)
end program diceroll
```
