## Write Foldable instances for the following datatypes.

1. Feel like this solution is not correct
```haskell
data Constant a b = Constant a

instance Monoid a => Foldable (Constant a) where
  foldMap _ _ = mempty
```

2. 
```haskell
data Two a b = Two a b deriving Show

instance Foldable (Two a) where
  foldMap f (Two a b) = f b
```

3.
```haskell
data Three a b c = Three a b c deriving Show

instance Foldable (Three a b) where
  foldMap f (Three _ _ c) = f c
```

4.
```haskell
data Three' a b = Three' a b b

instance Foldable (Three' a b) where
  foldMap f (Three' _ x y) = f x `mappend` f y
```

5.
```haskell
data Four' a b = Four' a b b b

instance Foldable (Four' a b) where
  foldMap f (Four' _ x y z) = f x `mappend` f y `mappend` f z
```

6. Thinking cap time. Write a filter function for Foldable types using `foldMap`.
```haskell
filterF :: (Applicative f, Foldable t, Monoid (f a)) => (a -> Bool) -> t a -> f a
filterF f = foldMap (\x -> if f x == True then pure x else mempty) 
```
