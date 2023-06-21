<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 24
  Purpose: Linear Search Notes
-->

# Linear Search Overview
- Unlike most search algorithms, list does not have to be sorted.
- Useful for data structures that do not have random access.
- Traverse list from beginning until element is found.

## Pseudo-Code
```lua
LinearSearch(A, value)
  for i = 0 to n do
    if A[i] == value then
      return i;
    fi
  rof

  return -1 -- Not found
end
```

# Performance
- Traverse the list until element is found, or worst case, not found; therefore **O**(n).
