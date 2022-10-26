<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 26
  Purpose: Heap Sort Notes
-->

# Heap Sort Overview
- Create a max-heap (parent > child) from unsorted array, heapify an assumed partially sorted array, swap largest (root) with smallest child (leaf) then remove largest, heapify->max-heap and repeat until there are no more nodes.

```c
/*
  Visual Example
 */
[ 2, 8, 5, 3, 9, 1]

// Represent array as tree
[ (2), (8, 5), (3, 9, 1)]

      (2)
  (8)     (5)
(3) (9) (1)

// Build max heap
      (9)
  (8)     (5)
(3) (2) (1)

//// Array representation
[ 9, 8, 5, 3, 2, 1 ]

// Largest item is 9, so swap with last element
[ 1, 8, 5, 3, 2, 9 ]
// New tree
      (1)
  (8)     (5)
(3) (2) (9)

// Remove 9 from the tree, and consider 9 sorted
      (1)
  (8)     (5)
(3) (2)

// Heapify since 1 is out of place
      (8)
  (3)     (5)
(1) (2)

//// Array representation
[ 8, 3, 5, 1, 2, 9 ]

// Largest item is 8 so swap with last element in unsorted segment
[ 2, 3, 5, 1, 8, 9 ]
// New tree
      (2)
  (3)     (5)
(1) (8)

// Remove 8 from tree and consider 8 sorted
      (2)
  (3)     (5)
(1)

// Heapify since 2 is out of place
      (5)
  (3)     (2)
(1)

//// Array representation
[ 5, 3, 2, 1, 8, 9 ]

// Largest item is 5 so swap with last element in unsorted segment
[ 1, 3, 2, 5, 8, 9 ]
// New tree
      (1)
  (3)     (2)
(5)

// Remove 5 from tree and consider 5 sorted
      (1)
  (3)     (2)

// Heapify since 1 is out of place
      (3)
  (1)     (2)

//// Array representation
[ 3, 1, 2, 5, 8, 9 ]

// Largest item is 3 so swap with last element in unsorted segment
[ 2, 1, 3, 5, 8, 9 ]
// New tree
      (2)
  (1)     (3)

// Remove 3 from tree and consider 3 sorted
      (2)
  (1)

// Heapify but nothing changes since no element is out of place
//// Array representation
[ 2, 1, 3, 5, 8, 9 ]

// Largest item is 2 so swap with last element in unsorted segment
[ 1, 2, 3, 5, 8, 9 ]
// New tree
      (1)
  (2)

// Remove 2 from tree and consider 2 sorted
      (1)
// Only one node is left, we're done
//// Array representation
[ 1, 2, 3, 5, 8, 9 ]
```

## Pseudo-Code
```lua
Heapsort(A)
  BuildMaxHeap(A)
  for i = n to 1 do
    swap(A[1], A[i])
    n = n - 1
    Heapify(A, 1)
  rof
end

BuildMaxHeap(A)
  for i = n/2 to 1
    Heapify(a, i)
  rof
end

Heapify(A, i)
  l = 2*i
  r = 2*i + 1
  if l <= n and A[l] > A[i] then
    max = l
  else 
    max = i
  fi

  if r <= n and A[r] > A[max] then
    max = r
  fi

  if max != i then
    swap(A[i], A[max])
    Heapify(A, max)
  fi
end
```

# Performance
- BuildMaxHeap is **O**(n).
- Heapify is **O**(log n) called n - 1 times.
- **O**(n log n)