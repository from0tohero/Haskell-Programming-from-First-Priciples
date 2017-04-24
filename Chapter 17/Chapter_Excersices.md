`Either a b`
```haskell
data Sum a b = First a | Second b deriving (Eq, Show)

instance Functor (Sum a) where
  fmap _ (First a) = First a
  fmap f (Second b) = Second $ f b

instance Applicative (Sum a) where
  pure x = Second x
  First e <*> _ = First e
  _ <*> First e = First e
  Second f <*> Second x = Second $ f x

instance Monad (Sum a) where
  return = pure
  First e >>= _  = First e
  Second x >>= f = f x
```
