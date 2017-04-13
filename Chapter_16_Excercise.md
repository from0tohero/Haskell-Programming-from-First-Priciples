## Determine if a valid `Functor` can be written for the datatype provided.
1. `data Bool = False | True`  
No, since the `Functor` needs a type with kind of `* -> *`
2. `data BoolAndSomethingElse a = False' a | True' a`
Yes
```haskell
data BoolAndSomethingElse a = False' a | True' a

instance Functor BoolAndSomethingElse where
  fmap f False' a  = False' $ f a
  fmap f True' a  = True' $ f a
```
3. `newtype Mu f = InF { outF :: f (Mu f) }`
No, the kind of `Mu` is `(* -> *) -> *`. We cannot make it.
