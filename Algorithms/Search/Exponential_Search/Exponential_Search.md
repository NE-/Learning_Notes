<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 26
  Purpose: Exponential Search Notes
-->

# Exponential Search Overview
- Assumes sorted list.
- Find a range where element may be present then perform binary search.

## Pseudo-Code
```lua
ExponentialSearch(A, e)
  if A[0] == e then
    return 0
  fi

  i = 1
  while i < n and A[i] <= e do
    i *= 2
  elihw

  return BinarySearch(a, i/2, min(i, n-1), e)
end
```

# Performance
- Doubles index to next power of 2. **O**(log n).
