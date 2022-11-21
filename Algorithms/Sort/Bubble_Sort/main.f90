!!!
! Author: NE- https://github.com/NE-
! Date: 2022 November 21
! Purpose: Bubble Sort implementation in Fortran
!!!

program BubSort
  implicit none
  integer, dimension(9) :: arr = (/ 4, 67, 2, 7, 14, 27, 86, 6, 1 /)
  integer :: m

  call bubble_sort(arr)

  ! Print sorted array
  print "(9i3)", (arr(m), m=1,size(arr))

  ! Worst case sort
  arr = (/ 9, 8, 7, 6, 5, 4, 3, 2, 1 /)

  call bubble_sort(arr)

  ! Print sorted array
  print "(9i3)", (arr(m), m=1,size(arr))
  
contains
  !!!
  ! @brief Implementation of Bubble Sort
  ! 
  ! @param arr Integer array to be sorted
  ! @param n   Length of the array
  ! 
  !!!
  subroutine bubble_sort(arr)
    implicit none
    integer, intent(out) :: arr(:)
    logical :: swapped ! Prevent redundant array scanning
    integer :: i, j, temp

    ! Loop entire array
    do i = 1, size(arr)
      swapped = .FALSE.

      do j = 1, size(arr) - i
        ! If current > next, bubble up
        if (arr(j) > arr(j+1)) then
          temp     = arr(j)
          arr(j)   = arr(j+1)
          arr(j+1) = temp
          swapped = .TRUE.
        end if
      end do
       ! No swap? already sorted
      if (.not. swapped) return
    end do
  end subroutine bubble_sort

end program BubSort
