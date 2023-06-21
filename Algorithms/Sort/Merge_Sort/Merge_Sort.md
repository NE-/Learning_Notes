<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 26
  Purpose: Merge Sort Notes
-->

# Merge Sort Overview
- Continuously split array in half until left with individual items, examine the items, compare their values and merge into temporary arrays. Jump up recursion, merge smaller arrays into larger arrays in the correct order. Continue until array is sorted.
- Usually recursive.

```c
/*
  Visual Example
 */
[ 2, 8, 5, 3, 9, 4, 1, 7 ]
// Split
[ 2, 8, 5, 3,] [ 9, 4, 1, 7 ]
// Split
[ 2, 8 ] [ 5, 3 ] [ 9, 4 ] [ 1, 7 ]
// Split
[ 2 ] [ 8 ] [ 5 ] [ 3 ] [ 9 ] [ 4 ] [ 1 ] [ 7 ]
// Compare and merge
[ 2, 8 ] [ 3, 5 ] [ 4, 9 ] [ 1, 7 ]
// Compare and merge
[ 2, 3, 5, 8 ] [ 1, 4, 7, 9 ]
// Compare and merge
[ 1, 2, 3, 4, 5, 7, 8, 9 ]
```

## Pseudo-Code
```lua
MergeSort(A, Li, Ri)
  if Li < Ri then
    m = Li + (Ri - Li) / 2
    MergeSort(A, Li, m)
    MergeSort(A, m+1, Ri)
    Merge(A, Li, m, Ri)
  fi
end

Merge(A, Li, m, Ri)
  i,j,k = 0,0,0
  n1 = m - Li + 1
  n2 = Ri - m

  -- Create new arrays
  L[n1]
  R[n2]

  for i=0 to n1 do
    L[i] = A[Li + i]
  rof
  for j = 0 to n2 do
    R[j] = A[m+1+j]
  rof

  i,j,k = 0,0,Li
  while i< n1 and j < n2
    if L[i] <= R[j] then 
      A[k] = L[i]
      ++i
    else
      A[k] = R[j]
      ++j
    fi
    ++k;
  elihw

  while i < n1 do
    A[k] = L[i]
    ++i
    ++k
  elihw
  while j < n2 do
    A[k] = R[j]
  elihw
end

-- Call
MergeSort(array, 0, n-1)
```

# Performace
- Merge takes N; log N for the binary tree produced by the splitting process.
- **O**(n log n)
