<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 26
  Purpose: Jump Search Notes
-->

# Jump Search Overview
- Assumes sorted list.
- Jumps and checks indices 0, m, 2m ... km until A\[km\] < x < A\[(k+1) * m\], then a linear search is done in that interval.
- Jump size *m* usually sqrt(n).

## Pseudo-Code
```lua
JumpSearch(A, e)
  step = sqrt(n)
  while A[min(step, n) - 1] < e do
    prev = step
    step += sqrt(n)
    if prev >= n then
      return -1
    fi
  elihw
  while A[prev] < x do
    ++prev
    if prev == min(step, n) then
      return -1
    fi
  elihw
  if A[prev] == x then
    return prev
  fi

  return -1
end
```

# Performance
- Perform n/m jumps then do linear search for m-1 elements.
- **O**(n/m + m-1) or **O**(√n)
