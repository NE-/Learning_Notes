<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 19
  Purpose: C++ Loops
-->

# Loops
```cpp
/*
  While condition is true
    run the block
 */
while (<condition>) {}

// Only the last statement/condition will be evaluated
while (++i, 2+2, i < 5) {}

/*
  Do 
    code block
  while condition is true

  Code block always executes at least once
 */
do {

}
while (<condition>);

/*
  for(
    init-statement; 
    condition;
    end-expression
  )
    Run the block

  Any statement or condition can br omitted
    omitted condition assumes true
 */
for (int i{0}, j{2}; i <= 2; ++i, ++j) {}
for (
  char c{' '}; // init c
  c != 'y';  // Run while c is not 'y'
  std::cout << "Exit [y/n]?\n", // Prompt user
  std::cin >> c // Get user input
){}
```

# Break and Continue
- Used to interrupt flow of the loop.
  - Because of flow manipulation, many peopole recommend not using them; however, it's not bad practice but does require close monitoring!
- `break` breaks out of the statement and continues flow outside of the statement.
- `continue` ends the current iteration and sends flow to the end of the loop.
