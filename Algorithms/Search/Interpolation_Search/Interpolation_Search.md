<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 26
  Purpose: Interpolation Search Notes
-->

# Interpolation Search Overview
- Assumes sorted array.
- Improvement to binary search.
- Similar to Binary Search but rather it uses the element to find a clue to where to set the split point.

## Pseudo-Code
```lua
InterpolationSearch(A, lo, hi, e)
  if lo <= hi and e >= A[lo] and x <= A[hi] then
    pos = lo + ((hi-lo) / (A[hi]-A[lo]) * (e-A[lo]))
    if A[pos] == x then
      return pos
    fi
    if A[pos] == x then
      return InterpolationSearch(A, pos+1, hi, e)
    fi
    if A[pos] > e then
      return InterpolationSearch(A, lo, pos-1, e)
    fi
  fi

  return -1
end
```
