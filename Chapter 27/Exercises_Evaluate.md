## Expand the expression in as much detail as possible. Then, work outside-in to see what the expression evaluates to.

1. `const 1 undefined`  
`const` has type `a -> b -> a`, when we apply `const` to two arguments, since it only cares of the first argument, so the second 
argument will not be evaluated. Therefore, in this case, `undefined` does not affect the program.  
**Result**: `1`

2. `const undefined 1`
The first argument, in this case `undefined`, for `const` will be the output of the `const` function.
**Result**: `undefined`

3. `flip const undefined 1`
`flip` has type of `(a -> b -> c) -> b -> a -> c`, `const` has type of `a -> b -> a`, `flip const` has type of `b -> a -> b`, 
therefore, only the first argument will be evaluated.  
**Result**: `1`

4. `flip const 1 undefined`
Similar to 3.  
**Result**: `undefined`

5. `const undefined undefined`  
**Result**: `undefined`

6. `foldr const 'z' ['a' .. 'e']`  
*Remainder*: foldl evaluates from left to right (left-associative). foldr evaluates from right to left (right-associative). Both of them 
consume the list from **left** to **right**.  
For this problem, since the the first step `const 'a' 'z' = 'a'` has the final answer, there 
is no need to continue go through the list.
**Result**: `a`
7. `foldr (flip const) 'z' ['a' .. 'e']`  
This one will go throught the list since the `flip const` will need its second argument as final result.  
If `['a'..'z']` were a 
variable, say `l`, then `:sprint l` after `foldr` will be `"abcde"`.  
*I thought the `l` will not be evaluated to WNF??*  
**Result**: `z`
