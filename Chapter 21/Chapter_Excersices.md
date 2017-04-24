## Traversable instances
#### Write a Traversable instance for the datatype provided, filling in any required superclasses. Use QuickCheck to validate your instances.

#### Identity
```haskell
newtype Identity a = Identity a deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap f (Identity x) = Identity $ f x 

instance Foldable Identity where
  foldMap f (Identity x) = f x 

-- Traversable has to be Functor + Foldable
instance Traversable Identity where
  traverse f (Identity x) = fmap Identity (f x)
```

#### Constant
```haskell
newtype Constant a b = Constant { getConstant :: a }

instance Functor (Constant a) where
  fmap _ (Constant x) = Constant x

instance Foldable (Constant a) where
  foldMap _ _ = mempty

instance Traversable (Constant a) where
  traverse f (Constant x) = pure $ Constant x
```
