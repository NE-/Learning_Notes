!!!
! Author:  NE- https://github.com/NE-
! Date:    2022 November 04
! Purpose: Binary Search implementation in Fortran
!!!

program BinSearch
  implicit none

  integer, parameter, dimension(9) :: arr = (/ 1,4,15,27,29,34,36,57,68 /)
  integer :: m

  ! Print the array
  print "(a2, 9i3, a2)", "[ ", (arr(m), m=1,9), " ]"

  ! Tests
  print "(a, i3)", "Number 1 in index ",   BinarySearch(arr, 1)
  print "(a, i3)", "Number 68 in index ",  BinarySearch(arr, 68)
  print "(a, i3)", "Number 29 in index ",  BinarySearch(arr, 29)
  print "(a, i3)", "Number 234 in index ", BinarySearch(arr, 234)


contains
  !!!
  ! @brief Implementation of Binary Search
  ! 
  ! @param arr - Integer array to be searched
  ! @param x   - Element to be found
  ! 
  ! @return Index where element is stored
  !         -1 if element not found in array
  !!!
  integer function BinarySearch(arr, x) result(retVal)
    implicit none
    integer, intent(in) :: arr(:), x
    integer :: start ! Store start of sublist
    integer :: end   ! Store end of sublist
    integer :: mid   ! Store mid of sublist 

    ! Initialize variables
    start = 1
    end = size(arr)
    mid = -1

    ! While there is a sublist to search
    do while (start <= end)
      mid = ishft(start+end, -1) ! Get the floored mid-index

      ! If element has been found
      if (arr(mid) == x) then
        retVal = mid
        return ! Return current mid-index
      !Otherwise, if element is less than element at current mid-index
      else if (x < arr(mid)) then
        end = mid - 1 ! Element to be found must be on bottom half
      ! Otherwise, element to be found is greater than current mid-index
      else 
        start = mid + 1 ! Therefore it must be on the upper half
      end if
    end do

    ! Element was not found
    retVal = -1
  end function BinarySearch
  
end program BinSearch
