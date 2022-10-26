<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 25
  Purpose: Insertion Sort Notes
-->

# Insertion Sort Overview
- Iterates list and inserts element in correct position of an already sorted portion.
```c
/*
  Visual Example
 */
 [4,3,2,1]

 [4] [3,2,1] // Sort 4
 [3,4] [2,1] // Sort 3
 [2,3,4] [1] // Sort 2
 [1,2,3,4]   // Sort 1
```
## Pseudo-Code
```lua
for i=1 to n do
  for j=1; j > 0 and A[j] < A[j-1]; --j
    swap(A[j], A[j-1])
  rof
rof
```

# Performance
- Traverse every remaining element for every element present; therefore **O**(n<sup>2</sup>).