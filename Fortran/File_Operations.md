<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 02
  Purpose: General Fortran (95/2003/2008) File Operation Notes.
-->

# File Operations
## Open
```fortran
open(
  unit=    <unit number>,   &
  file=    <file name>,     &
  status=  <file status>,   &
  action=  <file action>,   &
  position=<file position>, &
  iostat=  <status variable>
)
```

 | Clause | Explanation |
 | ------ | ----------- |
 | unit | Unit number for file operation (read, write, etc.). Typically integer between 10 and 99. |
 | file | Name of file to be open. Character literal or variable. |
 | status | Status of file.<br>"old": File must already exist.<br>"new": New file will be created.<br>"replace": New file will be created, replacing existing one if necessary. |
 | action | Action or open operation. <br>"read": Read data from file.<br>"write": write data to file.<br>"readwrite": Simultaneously read data from and write data to a file. |
 | position | Position or place to start.<br>"rewind": beginning.<br>"append": end. |
 | iostat | Variable for placing status code of operation.<br> 0 means successful, >0 means error (operation unsuccessful).

 ## Write
 - File must be open for "write" or "readwrite".
 ```fortran
 write(
   unit=<unit number>,     &
   fmt=<format statement>, &
   advance="no",           &
   iostat=<variable>
 )                         &
 <variables/expressions>
```
- `advance="no"` next write will be on same line of previous line.
```fortran
! Example writing to a file

integer :: myans=42, opstat, wtstat
real, parameter :: pi = 3.14159
character(11) :: msg="Hello World"
character(8) :: filename="temp.txt"

open (unit=10, file=filename, status="replace", &
      action="write", position="rewind",        &
      iostat=opstat)

if (opstat > 0) stop "Cannot open file!"

write (10, '(a/, i5/, f7.5)', iostat=wtstat)    &
       msg, myans, pi
```

### Stop Statement
- `stop` immediately terminates the program.
  - Optional following string will be displayed to stdout.

## Read
- File must be open for "read" or "readwrite" operations.
```fortran
read (
  unit=  <unit number>,      &
  fmt=   <format statement>, &
  iostat=<variable>
)                            &
<variables>
```
- `unit` must be the same as `open`'s `unit` number.
- If `iostat` variable is < 0, indicates end-of-file has been reached.

```fortran
! Example reading from file

integer :: num1, num2, opstat, rdstat
character(11) :: filename="numbers.txt"

open (unit=12, file=filename, status="old", &
      action="read", position="rewind",     &
      iostat=opstat
)

if (opstat > 0) stop "Cannot open file!"

read (12, '(i5)', iostat=rdstat) num1
read (12, '(i5)', iostat=rdstat) num2
```

## Rewind
- `rewind(<unit number>)` resets file read pointer (back to beginning of file).
  - `<unit number>` same as initial `open`'s `unit` number.
- *File must be open when rewind is executed.*

## Backspace
- `backspace(<unit number>)` re-reads line.
  - System reads line then jumps to next, `backspace` prevents jump.
  - `<unit number>` same as initial `open`'s `unit` number.
- *File must be open when rewind is executed.*
- Rarely used operation.

## Close File
- `close <unit number>` close file when it is no longer needed.
  - `<unit number>` same as initial `open`'s `unit` number.

```fortran
! Example read user-entered file
! read line from file, then write 
! line number and line to output file

program linenums

  implicit none

  integer :: i, rdopst, wropst, rdst
  character(30)  :: rdfile, wrfile
  character(132) :: line

  ! Display header
  write (*,*) "Line Number Example"

  ! Prompt for input file
  do
    write (*,'(a)', advance="no") "Input File Name: "
    read (*,*) rdfile

    ! Open input file
    open (12, file=rdfile, status="old",   &
          action="read",position="rewind", &
          iostat=rdopst
    )

    ! Break loop on success
    if (rdopst == 0) exit 

    ! Else unsuccessful open occured
    write (*,'(a/,a)') "Unable to open input file.", &
                       "Please re-enter"
  end do

  ! Prompt for output file
  do
    write (*,'(a)', advance="no") "Output File Name: "
    read (*,*) wrfile

    ! Open output file
    open (14, file=wrfile, status="replace", &
          action="write", position="rewind", &
          iostat=wropst
    )

    ! Break loop on success
    if (wropst==0) exit

    ! Else unsuccessful open occured
    write (*,'(a, a/, a)') "Unable to open.", &
                           "Please re-enter."
  end do

  i = 1

  do
    ! Read line from input file
    read (12, '(a)', iostat=rdstat) line

    ! If EOF exit loop
    if (rdst > 0) stop "read error"
    if (rdst < 0) exit

    ! Write line number and line to output file
    write (14, '(i10,2x,a)') i, line
    i = i + 1
  end do

  ! Close files
  close(12)
  close(14)
end program linenums
```
