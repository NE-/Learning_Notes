/*
  Author:  NE- https://github.com/NE-
  Date:    2022 November 21
  Purpose: Bubble Sort implementation
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

/**
 * @brief Implementation of Bubble Sort
 * 
 * @param arr - Integer array to be sorted
 * @param n   - Length of the array
 * 
 */

void bubble_sort(int arr[], size_t n) {
  bool swapped = false; // Prevent redundant array scanning

  // Loop entire array - 1
  for (size_t i = 0; i < n - 1; ++i) {
    swapped = false;

    // Check unsorted partition
    for (size_t j = 0; j < n - i - 1; ++j) {
      // If current > next, bubble up
      if (arr[j] > arr[j+1]) {
        int temp = arr[j];
        arr[j]   = arr[j+1];
        arr[j+1] = temp;
        swapped = true;
      }
    }
    if (!swapped) return; // No swap? already sorted
  }
}

int main(int argc, char const *argv[]) {
  int arr[] = { 4, 67, 2, 7, 14, 27, 86, 6, 1 };
  const size_t n = sizeof(arr) / sizeof(arr[0]);

  bubble_sort(arr, n);

  // Print sorted array
  for (size_t i = 0; i < n; ++i) {
    printf("%d ", arr[i]);
    arr[i] = n - i; // { 9, 8, 7, 6, 5, 4, 3, 2, 1 }
  }
  putc('\n', stdout);

  // Sort worse case
  bubble_sort(arr, n);

  // Print sorted array
  for (size_t i = 0; i < n; ++i) {
    printf("%d ", arr[i]);
  }
  putc('\n', stdout);

  return 0;
}
