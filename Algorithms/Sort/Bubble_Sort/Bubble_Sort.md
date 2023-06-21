<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 25
  Purpose: Bubble Sort Notes
-->

# Bubble Sort Overiew
- Iterate the list and swap if the current element is greater than the next.

```js
/*
  Visual Example
 */
//Current is 3
[3,2,1]
// 3 > 2 so swap
[2,3,1]
// 3 > 1 so swap
[2,1,3]
//3 is in sorted position

/** NEXT PASS **/
// Current is 2
[2,1,3]
// 2 > 1 so swap
[1,2,3]
// 3 is sorted so no check needed
// 2 is in sorted position

// 1 is the final so no need to check
// Sort completed
```

## Pseudo-Code
```lua
for i=0 to n-1 do
  swapped = false

  for j = 0 to n-i-1 do
    if A[j] > A[j+1] then
      swap(A[j], A[j+1])
      swapped = true
    fi
  rof
  if not swapped then break fi
rof
```

# Performance
- Both loops run n - 1 times and the comparison runs at constant time, therefore: (n - 1) × (n - 1) × C.
  - Cn<sup>2</sup> - 2Cn + 1 ➜ **O**(n<sup>2</sup>)
