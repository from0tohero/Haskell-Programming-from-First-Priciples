# 15.14 Chapter exercises
## Semigroup exercises
1. `Trivial`
```haskell
data Trivial = Trivial deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial
```
2. `Identity a`
```haskell
newtype Identity a = Identity a
  deriving (Show)
  
instance Semigroup (Identity a) where
  Identity x <> _ = Identity x
```
3. `Two a b`
```haskell
data Two a b = Two a b
  deriving (Show)
  
instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  Two x y <> Two x' y' = Two (x <> x') (y <> y')
```
4. `Three a b c`
```haskell
data Three a b c = Three a b c
  deriving (Show)
  
instance (Semigroup a, Semigroup b, Semigroup c) => Semigroup (Three a b c) where
  Three x y z <> Three x' y' z' = Three (x <> x') (y <> y') (z <> z')
```
5. `Four a b c d`
```haskell
data Four a b c d = Four a b c d
  deriving (Show)
  
instance (Semigroup a, Semigroup b, Semigroup c, Semigroup d) => Semigroup (Four a b c d) where
  Four x y z o <> Four x' y' z' o' = Four (x <> x') (y <> y') (z <> z') (o <> o')
```
6. `BoolConj`
```haskell
newtype BoolConj = BoolConj Bool
  deriving (Show)

instance Semigroup BoolConj where
  BoolConj True <> True = BoolConj True
  _ <> _ = BoolConj False
```
7. `BoolDisj`
```haskell
newtype BoolDisj = BoolDisj Bool
  deriving (Show)

instance Semigroup BoolDisj where
  BoolDisj False <> BoolDisj False = BoolDisj False
  _ <> _ = BoolDisj True
```
8. 'Or a b'
```haskell
data Or a b = Fst a | Snd b deriving (Show)

instance Semigroup (Or a b) where
  Snd x <> _ = Snd x
  Fst x <> res = res
```
9. `Combine a b` This one is a little bit tricky, see discussions on [StackOverflow](http://stackoverflow.com/questions/39456716/how-to-write-semigroup-instance-for-this-data-type/39456925)
```haskell
newtype Combine a b = Combine { unCombine :: (a -> b) }

instance Semigroup b => Semigroup (Combine a b) where
  Combine f <> Combine g = Combine $ \x -> (f x) <> (g x)
```