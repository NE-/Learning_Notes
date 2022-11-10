/*
  Author: NE- https://github.com/NE-
  Date: 2022 November 10
  Purpose: Linear Search implementation in C
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * @brief Implementation of Linear Search
 * 
 * @param arr Integer array to be searched
 * @param n   Length of the array
 * @param val Element to be found
 * 
 * @return Index where element is stored
 *         -1 if element not found in array
 */
int LinearSearch(int A[], size_t n, int val) {
  // Traverse entire array from beginning
  for (size_t i = 0; i < n; ++i) {
    if (A[i] == val) { // If the element has been found
      return i; // Return the index
    }
  }

  // Element not found
  return -1;
}

int main(int argc, char const *argv[]) {
  int arr[] = { 2, 6, 11, 16, 19, 25, 47, 49, 53 };
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
    "Element 2 at index %d\n",
    LinearSearch(arr, n, 2)
  );
  printf(
    "Element 19 at index %d\n",
    LinearSearch(arr, n, 19)
  );
  printf(
    "Element 49 at index %d\n",
    LinearSearch(arr, n, 49)
  );
  printf(
    "Element 87 at index %d\n",
    LinearSearch(arr, n, 87)
  );
  printf(
    "Element -34 at index %d\n",
    LinearSearch(arr, n, -34)
  );

  return 0;
}
