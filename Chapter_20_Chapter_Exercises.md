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
