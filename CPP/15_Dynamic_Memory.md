<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 21
  Purpose: C++ Dynamic Memory
-->

# Memory Allocation
- Used for dynamically allocating an amount of memory we don't know until runtime.
- **Static Memory**: Allocated at the beginning of the program and deallocated at the end.
- **Automatic Memory**: Allocated when a variable inside a block is created and destroyed at the end of the block.
- **Dynamic Memory**: Allocated and deallocated upon request.
```cpp
// Static
static constexpr double PI{ 3.14159 };

int main() {
  // Automatic
  int a{ 23 };

  // Automatic
  for (int i{0}; i < 5; ++i);

  // Dynamic
  new int;
}
```
## `new`
- `new` expression attempts to create and initialize an object on the heap (with dynamic storage duration), then returns a pointer to that object.
```cpp
new int;     // Dynamically allocate an int
new float;   // Dynamically allocate a float
new double;  // Dynamically allocate a double
new MyClass; // Dynamically allocate a class

new int{3};  // Dynamically allocate and initialize an int

// Check for failure
new (std::nothrow) int;
```
### `std::nothrow`
- Tells `new` to not throw an exception (`std::bad_alloc`) when allocation has failed, but rather, return a null pointer.
```cpp
// Without nothrow
try {
  new int[1000000000000000000];
} catch(const std::exception& e) {
  std::cout << e.what(); // std::bad_alloc
}

// With nothrow
try {
  new (std::nothrow) int[1000000000000000000];
} catch(const std::exception& e) {
  std::cout << e.what(); // Never called
}

// nothrow handling
int* ptr_i { new (std::nothrow) int[1000000000000000000] };

if (!ptr_i) {
  // Deal with the bad allocation
}
```
## `delete`
- Immediately returns the allocated memory back to the OS.
  - Deleting a pointer that doesn't point to dynamic memory may cause undefined behavior.
  - Using a deleted pointer that hasn't been nullified (dangling pointer) may cause undefined behavior.
```cpp
// Example dangling pointers

int* ptr1{ new int };
delete ptr1;

/*
  What is this pointing to?
  The same address?
  What if that address has 
  been claimed by another program?
 */
std::cout << *ptr1;

// Double dangling pointer
int* ptr2{ new int{ 2 } };
int* ptr3{ ptr2 };

delete ptr2;

// ptr2 and ptr3 are dangling
```
> Always nullify deleted pointers regardless of scope.<br>
> Also a good idea to check if a pointer isn't already null before deleting.

# Memory Leaks
- When dynamic memory never gets explicitly freed.
  - The operating system *may* check for and fix (reclaim) memory leaks, but we shouldn't rely on it!
- Normally caused by: pointer reassignment, goes out of scope before freeing, or early termination of a program.
```cpp
// Example Memory Leaks

// Reassignment
int a{0};
int* ptr{ new int };

/*
  The "new int"'s memory
  address is now lost;
  we don't know it, can't retrieve it,
  therefore unable to clean it.
 */
ptr = &a;

ptr = new int;
ptr = new int; // Previous allocation address is lost



// Pointer out of scope. Address lost
void allocate() {
  int* ptr{ new int };
}

{
  // Allocated
  int* ptr2{new int};
} // ptr2 destroyed but not the allocated memory block

std::cout << *ptr2; // ERROR ptr2 doesn't exist
```
## Return Dynamic Memory
- Instead of leaking out-of-scope, we can return the address.
```cpp
// Example return dynamic memory address
int* makePtr() {
  int* ptr { new int{ 34 }};

  return ptr;
}

// Usage
int* ptr_main{ makePtr() };

std::cout << *ptr_main; // 34

delete ptr_main;
ptr_main = nullptr;
```

# Dynamic Arrays
- Create memory for arrays at runtime. A beginner mistake is to make the array larger than you need to, but this is a waste of memory.
  - Sometimes even the user won't exactly know the size, so a common technique is to add a scalar to the dynamic array's size.
```cpp
std::size_t size{};

std::cout << "Enter size: ";
std::cin >> size;

int* arr{ new int[size] };

// Free
delete [] arr;
arr = nullptr;
```

## Multidimentional Arrays
- Just a pointer that holds pointers.
```cpp
int** arr2{ new int*[rows] };

// Create the columns.
// They don't all have to be the same size (rectangular)!
for (int i{0}; i < rows; ++i) {
  arr2[i] = new int[cols];
}

// Deallocate backwards from allocation
for (int i{0}; i < rows; ++i) {
  // First columns
  delete[] arr2[i];
}

// Then the entire container
delete[] arr2;
arr2 = nullptr;
```

# Smart Pointers
- Manage pointers automatically. C++11 defined in `<memory>`.

## `std::unique_ptr`
- Cleans up after it goes out of scope, gets explicitly deleted, is reassigned, or reset (member replaces the current object).
```cpp
std::unique_ptr<MyClass> myClass{ new MyClass };

// Deleted once out of scope
```
- You can use `new`, but it's recommended to use `std::make_unique` or `std::make_unique_for_overwrite` (C++20) instead because it wraps the object in a unique_ptr.
- Also use `.get()` to pass it as an argument.
```cpp
std::unique_ptr<A> myclass{ std::make_unique<A> }; // A created

// Also common to use auto
auto myclass2 { std::make_unique<A> }; // A created
```

## `std::shared_ptr`
- Ownership of object is shared. Cleaned up once the last shared_ptr of that object is destroyed or reassigned (with `=` or `reset()`).
- Also use `std::make_shared` instead of `new`.
- Internally, it uses two pointers: one for the sotred pointer and one for the control block.
  - Control block is a dynamically allocated object that points to either: the managed object, deleter, allocator, number of shared pointers, or number of weak pointers.
  - `std::shared_ptr` is *slightly* heavier than `std::unique_ptr` because of this.
- `std::shared_ptr`s can also point to each other; which is bad. This is known as a **reference cycle** and behaves similarly to a circular linked list.
  - The problem is technically, there is no "last shared pointer" so it never deallocates.
  - `std::weak_ptr` can break this cycle.

## `std::weak_ptr`
- `std::weak_ptr` behaves more like `std::shared_ptr` and are used together.
  - `std::weak_ptr` only has temporary ownership.
- They cannot be dereferenced, you'll have to cast them to a `shared_ptr` (using `lock()`).
- `std::weak_ptr`'s main use is to track the object, break reference cycles, or to preserve it for a short while, the store it in a `std::shared_ptr` afterwards.
- They have two internal pointers: one to the control block and another to the `shared_ptr` it was constructed from.

## `std::auto_ptr`
- "First" smart pointer which was the blueprint for `unique_ptr`. Deprecated in C++11 and removed in C++17.