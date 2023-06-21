!!!
! Author:  NE- https://github.com/NE-
! Date:    2022 November 10
! Purpose: Linear Search implementation in Fortran
!!!

program LinSearch
  implicit none

  integer, parameter, dimension(9) :: arr = (/ 2, 6, 11, 16, 19, 25, 47, 49, 53 /)
  integer :: m

  ! Print the array
  print "(a2, 9i3, a2)", "[ ", (arr(m), m=1,9), " ]"

  ! Tests
  print "(a, i3)", "Number 2 in index ",   LinearSearch(arr, 2)
  print "(a, i3)", "Number 19 in index ",  LinearSearch(arr, 19)
  print "(a, i3)", "Number 49 in index ",  LinearSearch(arr, 49)
  print "(a, i3)", "Number 87 in index ",  LinearSearch(arr, 87)
  print "(a, i3)", "Number -34 in index ", LinearSearch(arr, -34)

contains
  !!!
  ! @brief Implementation of Linear Search
  ! 
  ! @param arr - Integer array to be searched
  ! @param val - Element to be found
  ! 
  ! @return retVal Index where element is stored
  !                -1 if element not found in array
  !!!
  integer function LinearSearch(arr, val) result(retVal)
    implicit none
    integer, intent(in) :: arr(:), val
    integer :: i

    ! Traverse the entire array from beginning
    do i = 1, size(arr)
      if (arr(i) == val) then ! If element has been found
        retVal = i ! Return the index
        return
      end if
    end do
    
    ! Element was not found
    retVal = -1
  end function LinearSearch
  
end program LinSearch
