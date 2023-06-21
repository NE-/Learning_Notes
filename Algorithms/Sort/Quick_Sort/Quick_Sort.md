<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 25
  Purpose: Quick Sort Notes
-->

# Quicksort Overview
- Uses divide-and-conquer approach and utilizes a pivot.
  - Pivot should end up in correct position in the final sorted array.
  - Items to the left of pivot are smaller/less than.
  - Items to the right of pivot are larger/greater than.
    - *At this stage, order does not matter as long as the two rules are satisfied*.
- Choosing a pivot and organizing (left is less than and right is greater than pivot) is called *partitioning* the list.
- After, we break the array into two segments: elements that were on the left and right of pivot.
  - Keep track of start and end of segments!
- Repeat partioning of the segmented lists.
- New segments will be created, and partitioning and breaking repeats until we have only one element remaining.
- Best for in-memory sorting (O(1) space).

## Choosing a Pivot
- **Median of Three**: look at first, middle, and last elements. Sort them properly, then choose middle as pivot.
  - Assumes median of entire array.

## Pseudo-Code
```lua
QuickSort(A, start, end)
  if start < end then
    pI = Partition(A, start, end)
    QuickSort(A, start, pI - 1)
    QuickSort(A, pI + 1, end)
  fi
end

Partition(A, start, end)
  pivot = A[end]
  pI = start
  for i = start to end
    if A[i] <= pivot then
      swap(A[i], A[pI])
      pI++
    fi
  rof
  swap(A[pI], a[end])
  return pI
end
```


# Performance
- **O**(log n). average **O**(n log n).
- Worst n<sup>2</sup> which can be prevented with randomized partition version.
- Analysis based on a binary tree since we segment the array.
