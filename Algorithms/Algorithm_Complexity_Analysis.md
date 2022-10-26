<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 25
  Purpose: Algorithm Complexity and Analysis Notes
-->

# Complexity Summary
## Big Theta Ө
- **Tight bound**
- Analogy: `=`
- `f(x) = Ө(g(x)) <=> g(x) = Ө(f(x))`
  - Grow at the same rate. Ө(n<sup>3</sup>) != Ө(n<sup>2</sup>)
> Θ (g(n)) = { f(n): there exist positive constants c1, c2 and n0 such that 0 ≤ c1 \* g(n) ≤ f(n) ≤ c2 \* g(n) for all n ≥ n0 }

## Big Omega Ω
- **Asymptotic. Lower bound. Worst case. Imprecise**
- Analogy `>=`
- ω rare; not important. `g(n) = o(f(n))` Analogy `>`.
- For large enough *n*, time at least `k*f(n)` for constant *k*.

## Big O
- **Precise. asymptotic. Upper bound**
- Analogy: `<=`
- `f = O(g) iff constant A for all n f(n)/g(n) <= A`
### Little o
- Mathematics, rare in CS. 
- Analogy: `<`
- `f(x) = o(g(x))`
  - f grows slower than g and is insignificant in comparison.

## Growth functions
- 1                    => constant
- log(n)               => logarithmic
- (log(n))<sup>c</sup> => polylogarithmic
- n                    => linear
- n<sup>2</sup>        => quadratic
- n<sup>c</sup>        => polynomial
- c<sup>n</sup>        => exponential
- Grows faster than any power of n is *superpolynomial*.
- Grows slower than exponential function of the form c<sup>n</sup> is *subexponential*.

## Constant Time
- Perform same number of operations every time they're called.
- Arithmetics, assignments, tests (assignment, comparisons), read (of primitive types), write (of primitive type).

# Analysis
- Break down every statement and keep track number of times executed.

```js
let a = 1; // 1

for (
  let i = 0;                 // 1
  i < /*1*/ arr.length /*1*/ // Checked n times
  && /*1*/ a == 1 /*1*/;     // Checked n times
  ++i /*1*/                  // Executed n times
) {
  if (A[i] == toFind) { // Checked n times
    index = i;  // 1
    break;      // 1. Entire loop still n regardless of early termination
  }
}

/*
                  Analysis
   --- Parenthesis only for legibility ---
            for loop             if statement
  1 + (1 + 1n+1n + 1n+1n + 1n) + (1n + 1 + 1)
  O(4 + 6n) therefore O(n)
 */
```

## Common Mistakes
```lua
--[[ 
  Entire statement is n^2 
  regardless whether program
  executes if or else
--]]
if a < b then
  a = 1 -- 1
else
  for i=0 to n do
    for j = 0 to n do
      a = 2  -- n^2
    end
  end
end

--[[
  fun1() is n^2
--]]
fun1()
  fun2() -- n^2
end

--[[
  O(N + M)
]]
for i = 0 to N do end
for j = 0 to M do end

--[[
  O(N * M)
]]
for i = 0 to N do
  for j = 0 to M do
  end
end
```
