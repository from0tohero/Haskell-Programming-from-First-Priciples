Implement the functions in terms of foldMap or foldr from Foldable, then try them out with multiple types that have Foldable instances.

1. This and the next one are nicer with `foldMap`, but `foldr` is fine too
```haskell
sum :: (Foldable t, Num a) => t a -> a
sum :: getSum . foldMap Sum
```
2. 
```haskell
product :: (Foldable t, Num a) => t a -> a
product = getProduct . foldMap Product
```
3.
```haskell
elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem a = foldr (\x acc -> acc || x == a) False
```
4. This one is tricky, spent lots of times.
```haskell
import Data.Monoid

newtype Min a = Min { getMin :: Maybe a } deriving Show

-- Suppose mempty is the minimum
instance Ord a => Monoid (Min a) where
  mempty = Min Nothing
  mappend m@(Min (Just a)) n@(Min (Just b))
    | a < b = m
    | otherwise = n
  mappend mempty x@(Min (Just _)) = x
  mappend x@(Min (Just _)) mempty = x

minimum' :: (Foldable t, Ord a) => t a -> Maybe a
minimum' xs = getMin $ foldMap (\x -> Min {getMin = Just x}) xs
```
5.
```haskell
newtype Maximum a = Maximum { getMax :: Maybe a } deriving Show

instance Ord a => Monoid (Maximum a) where
  mempty = Maximum Nothing
  mappend m@(Maximum (Just x)) n@(Maximum (Just y))
    | x > y = m
    | otherwise = n
  mappend mempty m@(Maximum (Just _)) = m
  mappend m@(Maximum (Just _)) mempty = m

maximum' :: (Foldable t, Ord a) => t a -> Maybe a
maximum' = getMax . foldMap (\x -> Maximum (Just x)) 
```
6.  
Using `foldMap`
```haskell
import Data.Monoid

null' :: (Foldable t) => t a -> Bool
null' = getAll . foldMap (\x -> All False)
```
Using `foldr`
```haskell
null'' :: (Foldable t) => t a -> Bool
null'' = foldr (\x _ -> False) True
```

7.  
Using `foldr`
```haskell
length' :: (Foldable t) => t a -> Int
length' = foldr (\_ acc -> acc + 1) 0
```
Using `foldMap`
```haskell
import Data.Monoid

length' :: (Foldable t) => t a -> Int
length'' = getSum . foldMap (\_ -> Sum 1)
```
8.  
`foldr`
```haskell
toList :: Foldable t => t a -> [a]
toList = foldr (\x acc -> x : acc) []
```
`foldMap`
```haskell
toList' :: Foldable t => t a -> [a]
toList' = foldMap (\x -> [x])
```
9.
```haskell
-- | Combine the elements of a structure using a monoid.
fold :: (Foldable t, Monoid m) => t m -> m
fold = foldMap id
```
10. Define `foldMap` in terms of `foldr`.
```haskell
foldMap' :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
foldMap' f = foldr (\x acc -> f x `mappend` acc) mempty
```
