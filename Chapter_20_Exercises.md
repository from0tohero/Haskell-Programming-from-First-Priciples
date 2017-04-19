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

```
