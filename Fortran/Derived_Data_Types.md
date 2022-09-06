<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 05
  Purpose: General Fortran (95/2003/2008) Derived Data Type Notes.
-->

# Derived Data Types
- Combination of intristic data types.
```fortran
type <name>
  <component definitions>
end type <name>


! Student type
type student
  character(50) :: name
  integer       :: id
  real          :: score
  character(2)  :: grade
end type student


! Declaration
type (<type_name>) :: (<variable name(s)>)

type (student) :: stu1, stu2


! Accessing Components
!! Unset components can't be used
<variable_name>%<component_name>

stu1%name  = "Joseph"
stu1%id    = 1234
stu1%score = 99.99
stu1%grade = "A"

! Legal "copy" assignment
stu1 = stu2
```

## Arrays of Derived Data
```fortran
type(<type_name>), dimension(<extent>) :: <variable name(s)>

type(student), dimension(30) :: students

students(1)%name = "John"
students(2)%name = "April"

! swap
type(student) :: temp

temp = class(5)
class(5) = class(11)
class(11) = temp
```
---

```fortran
! Example calculate class average

program classScores

  implicit none

  type student
    character(60) :: name
    real          :: score
    character(1)  :: grade
  end type

  type(student), dimension(50) :: class
  integer :: count
  real :: average

  write (*, '(/,a,/)') "Class Average Calculator"

  ! Read student information
  call readStudents (class, count)

  call setStudentGrades (class, count)

  ! Calculate average
  average = classAverage (class, count)

  ! Display results
  write (*,'(/,a,f5.1)') "Final Average: ", average

contains

  subroutine readStudents (class, count)
  type(student), dimension(50), intent(out) :: class
  integer, intent(out) :: count = 0
  character(60) :: tempname
  real :: tempscore

    do
      ! Prompt for name
      write (*,'(a)', advance="no") "Enter student name: "
      read (*,'(a60)') tempname

      ! If name is empty, exit loop
      if (len_trim(tempname) == 0) exit

      do
        ! Prompt for score
        write (*,'(a)', advance="no") "Enter student score: "
        read (*,*) tempscore

        ! Check score entered 0 to 100 inclusive
        if (tempscore >= 0.0 .and. tempscore <= 100.0) exit

        ! Out of range error
        write (*,'(a,/,a)') "Error, invalid score." &
                            "Please re-enter (0-100)."
      end do

      ! Update student count
      count = count + 1

      ! Insert student into array
      class(count)%name  = tempname
      class(count)%score = tempscore
    end do

    return
  end subroutine readStudents

  subroutine setStudentGrades (class, count)
  type(student), dimension(50), intent(inout) :: class
  integer, intent(in) :: count
  integer :: i

    ! Check each score
    do i=1, count
      select case (nint(class(i)%score))
        case (90:)
          class(i)%grade = "A"
        case (80:89)
          class(i)%grade = "B"
        case (70:79)
          class(i)%grade = "C"
        case (60:69)
          class(i)%grade = "D"
        case (:59)
          class(i)%grade = "F"
      end select
    end do

    return
  end subroutine setStudentGrades

  real function classAverage (class, count)
  type(student), dimension(50), intent(in) :: class
  integer, intent(in) :: count
  integer :: i
  real :: sum = 0.0

    do i=1, count
      sum = sum + class(i)%score
    end do

    classaverage = sum / real(count)

    return
  end function classAverage

end program classScores
```
