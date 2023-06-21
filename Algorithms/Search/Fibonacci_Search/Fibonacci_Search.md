<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 26
  Purpose: Fibonacci Search Notes
-->

# Fibonacci Search
- Assumes sorted array.
- Similar to binary search, but does not use '/' operator, division of array is unequal, searches in smaller range.
- Segments are size of Fibonacci numbers.

## Pseudo-Code
```lua
FibSearch(A, e)
  f1=0
  f2=1
  f3 = f1 + f2

  while f3 < n do
    f1 = f2
    f2 = f3
    f3 = f1 + f2
  elihw

  offset = -1
  while f3 > 1 do
    i = min(offset + f1, n-1)
    if A[i] < e then
      f3 = f2
      f2 = f1
      f1 = f3 = f2
      offset = i
    elif A[i] > e then
      f3 = f1
      f2 = f2 - f1
      f1 = f3 - f2
    else 
      return i
    fi
  elihw

  if f2 and A[offset + 1] == e then
    return offset + 1
  fi

  return -1
end
```

# Performance
- **O**(log n)