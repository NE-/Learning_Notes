/*
  Author: NE- https://github.com/NE-
  Date: 2022 November 04
  Purpose: Binary Search implementation in C
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * @brief Implementation of Binary Search
 * 
 * @param arr Integer array to be searched
 * @param n   Length of the array
 * @param x   Element to be found
 * 
 * @return Index where element is stored
 *         -1 if element not found in array
 */

int BinarySearch(int arr[], size_t n, int x) {
  int start = 0;   // Store start of sublist
  int end = n - 1; // Store end of sublist
  int mid = -1;    // Store middle of sublist

  // While there is a sublist to search
  while (start <= end) {
    mid = (start + end) >> 1; // Get the floored mid-index

    // If element has been found
    if (arr[mid] == x)
      return mid;      // Return current mid-index
    // Otherwise, if element is less than element at current mid-index
    else if (x < arr[mid])
      end = mid - 1;   // Element to be found must be on bottom half
    // Otherwise, element to be found is greater than current mid-index
    else
      start = mid + 1; // Therefore it must be on the upper half
  }

  // Element was not found
  return -1;
}

int main(int argc, char const *argv[]) {
  int arr[] = { 1,4,15,27,29,34,36,57,68 };
  const size_t n = sizeof(arr) / sizeof(arr[0]);

  // Print the array
  for (size_t i = 0; i < n; ++i) {
    if (i == 0)fputc('[', stdout);
    printf(" %d", arr[i]);
    fputs(i == n-1 ? " ]" : ",", stdout);
  }
  fputc('\n', stdout);

  // Tests
  printf(
    "Number 1 in index %d\n",
    BinarySearch(arr, n, 1)
  );
  printf(
    "Number 68 in index %d\n",
    BinarySearch(arr, n, 68)
  );
  printf(
    "Number 29 in index %d\n",
    BinarySearch(arr, n, 29)
  );
  printf(
    "Number 234 in index %d\n",
    BinarySearch(arr, n, 234)
  );

  return 0;
}
