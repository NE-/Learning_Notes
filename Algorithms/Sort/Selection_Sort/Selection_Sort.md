<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 24
  Purpose: Selection Sort Notes
-->

# Selection Sort Overview
- During each iteration, take smallest item from the unsorted partition and move it to the sorted partition.
  - Usually has two element pointers: current minimum and current item.
- Better for object types e.g. elements are expensive to swap.
```js
/*
  Sort the following list
 */
// Initialization
let list = [2,8,5,3,9,4,1]
let min = list[0]; // Smallest number in list
let current = 1;   // Current index to check

// Traverse list[current] to find number smaller than min
/* 
  We find 1 to be < min, 
  so 1 is our new min (current = 6)
  and we swap with our current min

  1 is part of the sorted partition.

  variables are now
 */
list = [1,8,5,3,9,4,2]
min = 1;
current = 6;

/*
  Left side is sorted partition, so we dont touch it
  Moving on, we test the next element

  variables are now
 */
list = [1,8,5,3,9,4,2]
min = list[1];
current = 2;

/*
  5 < 8 so that's the new minimum
  3 < 5 so that's the new minimum
  2 < 3 so that's the new minimum
  traversing complete so we swap
  8 and 2

  variables are now
 */
list = [1,2,5,3,9,4,8]
min = 2;
current = 6;

/*
  Left side is sorted partition, so we dont touch it
  Moving on, we test the next element

  variables are now
 */
list = [1,2,5,3,9,4,8]
min = list[2];
current = 3;

/*
  3 < 5 so that's the new minimum
  Reach index 6 so we swap 5 and 3

  variables are now
 */
list = [1,2,3,5,9,4,8]
min = 3;
current = 6;

/*
  Left side is sorted partition, so we dont touch it
  Moving on, we test the next element

  variables are now
 */
list = [1,2,3,5,9,4,8]
min = list[3];
current = 4;

/*
  4 < 5 so that's the new minimum
  Reach index 6 so we swap

  variables are now
 */
list = [1,2,3,4,9,5,8]
min = 4;
current = 6;

/*
  Left side is sorted partition, so we dont touch it
  Moving on, we test the next element

  variables are now
 */
list = [1,2,3,4,9,5,8]
min = list[4];
current = 5;

/*
  5 < 9 so that's the new minimum
  Reach index 6 so we swap

  variables are now
 */
list = [1,2,3,4,5,9,8]
min = 5;
current = 6;

/*
  Left side is sorted partition, so we dont touch it
  Moving on, we test the next element

  variables are now
 */
list = [1,2,3,4,5,9,8]
min = list[5];
current = 6;

/*
  8 < 9 so that's the new minimum
  Reach index 6 so we swap

  variables are now
 */
list = [1,2,3,4,5,8,9]
min = 8;
current = 6;

/*
  We don't have to check the last
  element as there is nothing beyond
  to check, so the algorithm ends
  at n-1 iterations
 */
```

## Pseudo-Code
```lua
for j = 0 to n - 1 do
  iMin = j;

  for i = j+1 to n do
    if A[i] < A[iMin] then
      iMin = i;
    fi
  rof
  
  if iMin != j then
    swap(A[j], A[iMin])
  fi
rof
```

# Performance
- Nested loops that don't depend on the data in the array.
- Finding *minimum* requires scanning n elements and n-1 comparisons
  - Finding the next minimum requires scanning remaining n-2 elements and so on.
- (n - 1) + (n - 2) + ... + 1
  - (((n - 1) + 1) / 2) * (n - 1)
    - 1/2 * (n<sup>2</sup> - n) = **O**(n<sup>2</sup>)
