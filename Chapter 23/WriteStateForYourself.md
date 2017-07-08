## 23.6 Write State for yourself
### Defination
```haskell
newtype Moi s a = Moi { runMoi :: s -> (a, s) }
```
### State Functor
```haskell
instance Functor (Moi s) where
  fmap f (Moi g) = Moi $ \s  
    -> let (a, s') = g s 
       in (f a, s')
```
A clearer implementation
```haskell
instance Functor (Moi s) where
  fmap f (Moi g) = Moi $ \s -> let (a, s') = g s 
                               in (f a, s') 
```
### State Applicative
```haskell
instance Applicative (Moi s) where
  --pure :: a -> Moi s a
  pure a = Moi $ \s -> (a ,s)
  
  --(<*>) :: Moi s (a -> b) -> Moi s a -> Moi s b
  Moi f <*> Moi g = Moi $ \x
    -> let gx = g x
           fx = f x
           a' = (fst fx) (fst gx)
       in (a', snd gx)
```
Shorter implementation
```haskell
instance Applicative (Moi s) where
  pure a = Moi $ \s -> (a ,s)
  
  Moi f <*> Moi g = Moi $ \s
    -> let (ag, sg) = g s
           (af, sf) = f s
       in (af ag, sg)    
```
### State Monad
```haskell
instance Monad (Moi s) where
  return = pure
  
  --(>>==) :: Moi s a -> (a -> Moi s b) -> Moi s b
  (Moi f) >>= g = Moi $ \s
    -> let (a, s') = f s 
           Moi h  = g a 
       in h s'
```
ref: [Learn you a haskell a good way](http://learnyouahaskell.com/for-a-few-monads-more)
