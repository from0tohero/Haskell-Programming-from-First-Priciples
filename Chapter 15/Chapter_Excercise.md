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
  
instance Semigroup a => Semigroup (Identity a) where
  Identity x <> Identity y = Identity $ x <> y
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
  BoolConj True <> BoolConj True = BoolConj True
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
8. `Or a b`
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
10. `Combine a a`
```haskell
newtype Combine a b = Combine { unCombine :: (a -> a) }

instance Semigroup (Combine a b) where
  Combine f <> Combine g = Combine $ f.g
```
11. `Validation a b` 
```haskell
data Validation a b = Failure a | Success b
  deriving (Eq, Show)

instance Semigroup a => Semigroup (Validation a b) where
  Failure f <> Failure f' = Failure $ f <> f'
  Success s <> Success s' = Success s
  Failure f <> Success s  = Failure f
  Success s <> Failure f  = Failure f
```
12. `AccumulateRight (Validation a b)`
```haskell
newtype AccumulateRight a b = AccumulateRight (Validation a b)
  deriving (Eq, Show)

instance Semigroup b => Semigroup (AccumulateRight a b) where
  AccumulateRight (Success s) <> AccumulateRight (Success s') = AccumulateRight $ Success $ s <> s'
  AccumulateRight (Failure f) <> AccumulateRight (Success s)  = AccumulateRight $ Success s
  AccumulateRight (Success s) <> AccumulateRight (Failure f)  = AccumulateRight $ Success s
  AccumulateRight (Failure f) <> AccumulateRight (Failure f') = AccumulateRight $ Failure f 
```
13. `AccumulateBoth (Validation a b)`
```haskell
newtype AccumulateBoth a b = AccumulateBoth (Validation a b)
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b) =>
Semigroup (AccumulateBoth a b) where
  AccumulateBoth (Success s) <> AccumulateBoth (Success s') = AccumulateBoth $ Success $ s <> s'
  AccumulateBoth (Failure f) <> AccumulateBoth (Success s)  = AccumulateBoth $ Failure f
  AccumulateBoth (Success s) <> AccumulateBoth (Failure f)  = AccumulateBoth $ Failure f
  AccumulateBoth (Failure f) <> AccumulateBoth (Failure f') = AccumulateBoth $ Failure $ f <> f'
```
## Monoid exercises
1. `Trivial`
```haskell
data Trivial = Trivial deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial

instance Monoid Trivial where
  mempty = Trivial
  mappend = (<>)
```
2. `Identity a`
```haskell
newtype Identity a = Identity a deriving Show

instance Semigroup a => Semigroup (Identity a) where
  Identity x <> Identity y = Identity $ x <> y
  
instance (Semigroup a, Monoid a) => Monoid (Identity a) where
  mempty = Identity mempty
  mappend = (<>)
```
3. `data Two a b`
```haskell
data Two a b = Two a b deriving Show

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  Two x y <> Two x' y' = Two (x <> x') (y <> y')

instance (Semigroup a, Monoid a, Semigroup b, Monoid b) => Monoid (Two a b) where
  mempty = Two mempty mempty
  mappend = (<>)
```
4. `newtype BoolConj = BoolConj Bool`
```haskell
newtype BoolConj = BoolConj Bool

instance Semigroup BoolConj where
  BoolConj True <> BoolConj True = BoolConj True
  _ <> _ = BoolConj False

instance Monoid BoolConj where
  mempty = BoolConj False
  mappend = (<>)
```
5. `BoolDisj`
```haskell
newtype BoolDisj = BoolDisj Bool

instance Semigroup BoolDisj where
  BoolDisj True `mappend` BoolDisj True = BoolDisj True
  _ <> _ = BoolDisj False

instance Monoid BoolDisj where
  mempty = BoolDisj True
  mappend = (<>)
```
6. `Combine a b`
```haskell
newtype Combine a b = Combine { unCombine :: (a -> b) }

instance Semigroup b => Semigroup (Combine a b) where
  Combine f <> Combine g = Combine $ \x -> f x <> g x

instance (Semigroup b, Monoid b) => Monoid (Combine a b) where
  mempty = Combine $ \x -> mempty
  mappend = (<>)
```
7. `Combine a`
```haskell
newtype Combine a = Combine { unCombine :: (a -> a) }

instance Semigroup a => Semigroup (Combine a) where
  Combine f <> Combine g = Combine $ f . g

instance (Semigroup a, Monoid a) => Monoid (Combine a) where
  mempty = Combine mempty
  mappend = (<>)
```
8. `Mem s a = Mem { runMem :: s -> (a, s) }`  
This is tricky, `Mem` takes a function which takes an `s` as a input and returns a pair `(a, s)`, and `a` is a `Monoid` instance.  
As a instance of `Monoid`, the `mempty` of `Mem` should be a function which uses `mempty` of type `a`. The `mappend` should take two `Mem` and somehow combines their `a` part.
```haskell
newtype Mem s a = Mem { runMem :: s -> (a,s) }

instance Semigroup a => Semigroup (Mem s a) where
  Mem f <> Mem g = Mem h
    where h = \x -> (fst (f x) <> fst (g x), x)

instance (Semigroup a, Monoid a) => Monoid (Mem s a) where
  mempty = Mem $ \x -> (mempty, x)
  mappend = (<>)
```
