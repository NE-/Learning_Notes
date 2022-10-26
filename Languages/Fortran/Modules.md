<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 05
  Purpose: General Fortran (95/2003/2008) Modules Notes.
-->

# Modules
- Secondary source file.

## Module Declaration
```fortran
module <name>
  <declarations>
contains
  <subroutine and/or function definitions>
end module <name>

! Example
module stats

contains
  real function average(array, len)
    real intent(in), dimension(1000) :: array
    integer, intent(in) :: len
    integer :: i
    real :: sum = 0.0

    do i=1, len
      sum = sum + array(i)
    end do

    average = sum / real(len)
  end function average

end module stats
```

## Use Statement
- `use` is used to include modules.
- Placed before variable declarations.
```fortran
program average
  use stats

  implicit none

  real, dimension(1000) :: arr
  integer :: i, count
  real :: avg

  ! Initialize array
  count = 0
  do i=1, 20
    arr(i) = real(i) + 10.0
    count = count = 1
  end do

  ! Find average
  avg = average(arr, count)

  write (*, '(/, a, f10.2, /)') "Average = ", avg
end program average
```

## Compilation
- `gfortran -c stats.f95`
  - `-c` Compile, asseble, but don't link. Makes object (.o) and module (.mod) files.
- `gfortran -o myexe main.f95 stats.o`
  - *.mod* files are **required** for compilation.
---
```fortran
! Compute surface area and volume of a sphere

! ******** !
! main.f95 !
! ******** !
program sphere
  use sphereRoutines

  implicit none

  real :: radius, spVolume, spSurfaceArea

  ! Display header
  write (*,'(a/)') "Sphere Surface Area and Volume Calculator"

  ! Prompt for radius
  write (*,'(a)', advance="no") "Radius: "
  read (*,*) radius

  ! Get volume and radius
  spVolume = sphereVolume(radius)
  spSurfaceArea = sphereSurfaceArea(radius)

  ! Print results
  call displayResults(radius, spVolume, spSurfaceArea)
end program sphere


! ****************** !
! sphereroutines.f95 !
! ****************** !
module sphereRoutines

  implicit none

  ! Globals
  real, parameter :: pi = 3.14159

contains

  real function sphereVolume(radius)
  real, intent(in) :: radius
    sphereVolume = ((4.0*pi)/3.0) * radius ** 3

    return
  end function sphereVolume

  subroutine displayResults(rad, vol, area)
  real, intent(in) :: rad, vol, area
    
    write (*,'(/,a)') "-------------------------------"
    write (*,'(a)') "Results:"
    write (*,'(3x, a, f10.2)') "Sphere Radius = ", rad
    write (*,'(3x, a, f10.2)') "Sphere Volume = ", vol
    write (*,'(3x, a, f10.2, /)') "Sphere Surface Area = ", area

    return
  end subroutine displayResults
end module sphereRoutines
```

## Compilation
```
gfortran -c sphereroutines.f95
gfortran -o modmain modmain.f95 sphereroutines.o
```
