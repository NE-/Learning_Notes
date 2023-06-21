<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 24
  Purpose: Binary Search Notes
-->

# Binary Search Overview
- Assumes sorted list.
- Generally, start at middle of sorted list and eliminate half of the values each iteration and redo.
  - Returns index if successful, otherwise null.
  - Repeat algorithm while low pointer is <= high pointer
```js
/* 
  Find number 3 from following list
 */
// Initialization
let list = [1,2,3,4,5,6,7,8,9];
let low  = 0;
let high = 8; // Length of array
let mid = -1;

// Find floored (or ceiling) average of left-most ("low") index and right-most ("high").
mid = (low + high) / 2; // ⌊Avg(0, 8)⌋ = 4

// list[mid] > 3 therefore we eliminate top half
// Set new low and high
low = low; // Unchanged
high = mid - 1;

// Find new average
mid = (low + high) / 2; // ⌊Avg(0, 3)⌋ = 1

// list[mid] < 3 therefore we eliminate bottom half
// Set new low and high
low = mid + 1;
high = high; // Unchanged

// Find new average
mid = (low + high) / 2; // ⌊Avg(1, 3)⌋ = 2

// list[mid] = 3 we're done; return index
return mid;
```

## Hermann Bottenbrunch Implementation
- Leave out if *middle* element is equal to *target*.
  - Check performed only when one element is left.
```js
bin_HB(A, n, T) {
  let L = 0;
  let R = n - 1;

  while (L != R) {
    m = ciel((L+R)/2);
    if (A[m] > T) R = m - 1;
    else L = m;
  }
  if (A[L] == T) return L;

  return -1;
}
```

# Duplicate Elements
- Normal procedure will return leftmost element e.g. `[1,2,4,4,4,5,6,7]` would return `3`.

## Find left-most Element
```js
let L = 0;
let R = n;
while (L < R) {
  m = floor((L + R) / 2);
  if (A[m] < T) L = m + 1;
  else R = m;
}

return L;
```

## Find right-most Element
```js
let L = 0;
let R = n;
while (L < R) {
  m = floor((L + R) / 2);
  if (A[m] > T) R = m;
  else L = m + 1;
}
return R - 1;
```

# Performance
- Best viewed in binary tree syntax where root node is middle element of the array, mid of lower half is left child, mid of upper half is right child, and the rest is similar.
- **Worst Case**: ⌊log<sub>2</sub>(n) + 1⌋
  - Reached at *lowest* level of the tree.
  - Reached when element is not in the list.
    - Can be ⌊log<sub>2</sub>(n)⌋ if reached 2nd deepest level of tree.
- **Average Case**: **O**(log n)
## Space
- Requires 3 pointers to elements, regardless of the size of the list, therefore **O**(1).
