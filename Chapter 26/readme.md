# Some Monad Transformers Mentioned in The Book

### 1. `IdentityT`
This transformer is mainly used for educational purpose (*in my opnion*). Basically, it wraps a monadic 
structure inside the `Identity` type:
```haskell
newtype IdentityT m a = { runIdentityT :: m a }  -- type m should be a monadic instance
```
It is not hard to implement the `Functor` and `Applicative` instance for `IdentityT`. (*See IdentityT.hs*)  
For `bind`, let's do it step-by-step:
1. Type of the `>>=`:
```haskell
 >>= :: Monad m => IdentityT m a -> (a -> IdentityT m b) -> IdentityT m b
(>>=)              (IdentityT ma)   f
```
Therefore, we have `IdentityT ma` has type `IdentityT m a`, function `f` has type `a -> IdentityT m b`, 
and we know the return type is `IdentityT m b`

2. To apply the function `f` to `ma`, we have to use `fmap`:
```haskell
f  :: a -> IdentityT m b
ma :: m a
fmap f ma :: m (IdentityT m b)
```
3. From type `m (IdentityT m b)` to type `IdentityT m b`, we want to remove the outmost `m`, however there is no way to do so. 
Another way we can try is to remove the `IdentityT` in the middle:
```haskell
fmap :: (IdentityT m a1 -> m a1) -> m (IdentityT m b) -> m (m b)
fmap    runIdentityT                (fmap f ma)
```
4. We are close! Then use `join` to merge two `m` in the last equation:
```haskell
join :: m (m b) -> m b
```
5. Last step, apply `IdentityT` to the thing we got in last step, to make the type to be `IdentityT m b`
So the final answer is:
```haskell
 >>= :: Monad m => IdentityT m a -> (a -> IdentityT m b) -> IdentityT m b
(>>=)              (IdentityT ma)   f                    =  IdentityT $ join fmap runIdentityT (fmap f ma)
```
6. Last last step. Simplify the answer we have in step 5.
  * We know `fmap f (fmap g x) == fmap (f . g) x`, so 
```haskell
IdentityT $ join fmap runIdentityT (fmap f ma) == IdentityT $ join fmap (runIdentityT . f) ma
```
  * `join fmap == >>=`
```haskell
IdentityT $ join fmap (runIdentityT . f) ma == IdentityT $ ma >>= runIdentityT . f
```

### 2. `MaybeT`
Definition:
```haskell
newtype MaybeT m a = MaybeT {runMaybeT :: m (Maybe a) }
```
Functor def is similar to `Compose`, things become complicated when implementing the `(<*>)` for `Applicative` instance
```haskell
(<*>) :: MaybeT m (a -> b) -> MaybeT m a -> MaybeT m b
(<*>)    (MaybeT mf)          (MaybeT ma) = undefined
```
`mf` here has type `m (Maybe (a -> b))` and `ma` has type `m (Maybe a)`. We want to do some magic to `mf` to convert it 
to type `m (Maybe a -> Maybe b)` so that we can use `<*>` of `Applicative m` to apply to `ma :: m (Maybe a)`.  
Recall the defination of `<*> :: f (a -> b) -> f a -> f b`, it takes two arguments, if we pass it just one argument, then 
it becomes `(<*>) fab :: f a -> f b`. Therefore we can use this property.  
`fmap (<*>) mf` has type `m (Maybe a -> Maybe b)`, therefore we can apply this to `ma`.
Final result:
```haskell
(<*>) (MaybeT mf) (MaybeT ma) = MaybeT $ (<*>) <$> mf <*> ma
```
For `Monad` instance, we would like to take the inner part out, since `m` is also a `Monad`, we can use `<-` from `Monad` 
to get the `Maybe a` part.
