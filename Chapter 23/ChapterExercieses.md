## 23.8 Chapter Exercises
#### Write the following functions. You'll want to use your own `State` type for which you've defined the `Functor`, `Applicative`, and `Monad`.  
*I use my own `State`, which is named `Moi`, see the definition in source file*  

1. Construct a `Moi` where hte state is also the value you return.  
Expected output:
```haskell
Prelude> runMoi get "curryIsAmaze"
("curryIsAmaze", "curryIsAmaze")
```
Solution:
```haskell
get :: Moi s s
get = Moi $ \x -> (x, x)
```
2. Construct a `Moi` where the resulting state is the argument provided and the value is defaulted to unit.
Expected output:
```haskell
Prelude> runMoi (put "blah") "woot"
((), "blah")
```
Solution:
```haskell
put :: s -> Moi s ()
put s = Moi $ \s' -> ((), s)
```
3. Run the `Moi` with `s` and get the sate that results.
Expected output:
```haskell
Prelude> exec (put "wilma") "daphne"
"wilma"
Prelude> exec get "scooby papu"
"scooby papu"
```
Solution:
```haskell
exec :: Moi s a -> s  -> s
exec (Moi sa) s = snd $ sa s
```
4. Run the 'Moi' with `𝑠` and get the value that results.
Expect output:
```haskell
Prelude> eval get "bunnicula"
"bunnicula"
Prelude> eval get "stake a bunny"
"stake a bunny"
```
Solution:
```haskell
eval :: Moi s a -> s -> a
eval (Moi sa) s = fst $ sa s
```
5. Write a function which applies a function to create a new `Moi`.
Expect output
```haskell
Prelude> runMoi (modify (+1)) 0
((),1)
Prelude> runMoi (modify (+1) >> modify (+1)) 0
((),2)
```
Solution:
```haskell
modify :: (s -> s) -> Moi s ()
modify f = Moi $ \s -> ((), f s)
```
