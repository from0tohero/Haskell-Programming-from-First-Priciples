Defination:
```haskell
newtype Compose f g a =
  Compose { getCompose :: f (g a) }
  deriving (Eq, Show)
```
Functor instance
```haskell
instance (Functor f, Functor g) =>
         Functor (Compose f g) where
  fmap f (Compose fga) =
    Compose $ (fmap. fmap) f fga
             
```
Applicative:
1. How to implement pure?  
We have 2 layers to lift, so double `pure` should work. The inner `pure` has type `a -> g a`, and the outer `pure` is `(g a) -> f (g a)`. 
Don't forget to wrap with `Compose`
2. What about the `(<*>)`?
This one is tricky. There are 2 layers after removin the `Compose` wrapper, `f` and `g`, both of them are instance of applicative, we need a way to get into those 2 layers, one thing we can do 
is `fmap (<*>) fga` which equals to `[] Maybe (((a -> b) -> a) -> (a -> b) -> b)`, and we use `<*>` one more time, it works in magic! *Not quite sure about the explanation*
```haskell
instance (Applicative f, Applicative g) =>
         Applicative (Compose f g) where
  pure = Compose . pure . pure
    
  (Compose f) <*> (Compose a) =
    Compose $ (liftA2 (<*>)) f a
    -- or another way
    Compose $ (fmap (<*>) f <*> a)
```
