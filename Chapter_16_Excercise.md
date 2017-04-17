## Determine if a valid `Functor` can be written for the datatype provided.
1. `data Bool = False | True`  
No, since the `Functor` needs a type with kind of `* -> *`
2. `data BoolAndSomethingElse a = False' a | True' a`
Yes
```haskell
data BoolAndSomethingElse a = False' a | True' a

instance Functor BoolAndSomethingElse where
  fmap f False' a  = False' $ f a
  fmap f True' a  = True' $ f a
```
3. `data BoolAndMaybeSomethingElse a = Falsish | Truish a`
Yes
```haskell
data BoolAndMaybeSomethingElse a = Falsish | Truish a

instance Functor BoolAndMaybeSomethingElse where
  fmap _ Falsish = Falsish
  fmap f Truish x = Truish $ f x
```
4. `newtype Mu f = InF { outF :: f (Mu f) }`
No, the kind of `Mu` is `(* -> *) -> *`. We cannot make it.  
Not too sure about the explanation, something related to `Bi-Functor`?
[Stack Overflow](http://stackoverflow.com/questions/39770191/functor-instance-for-newtype-mu-f-inf-outf-f-mu-f)
5. `data D = D (Array Word Word) Int Int`
No, the kind of `D` is `*`
## Rearrange the arguments to the type constructor of the datatype so the Functor instance works.
1. From the instance implementation, we can see that, the `fmap` will map the function to `First` but keep `Second` not changed. In that case, `First a`, `a` has to be the second parameter of `Sum`. Therefore, the `Functor` of `Sum` type should be `Sum b a`
```haskell
data Sum b a =
  First a
| Second b

instance Functor (Sum b) where
  fmap f (First a) = First (f a)
  fmap f (Second b) = Second b
```
2. The structur of `Company`is `DeepBlue a c`
```haskell
data Company a c b =
  DeepBlue a c
| Something b

instance Functor (Company a c) where
fmap f (Something b) = Something (f b)
fmap _ (DeepBlue a c) = DeepBlue a c
```
3. 
```haskell
data More b a =
  L a b a
| R b a b
  deriving (Eq, Show)

instance Functor (More b) where
  fmap f (L a b a') = L (f a) b (f a')
  fmap f (R b a b') = R b (f a) b'
```
## Write Functor instances for the following datatypes.
1. 
```haskell
data Quant a b =
Finance
| Desk a
| Bloor b

instance Functor (Quant a) where
  fmap _ Finance = Finance
  fmap _ (Desk x) = Desk x
  fmap f (Bloor b) = Bloor $ f b
```
2. This one is interesting :)
```haskell
data K a b = K a deriving Show
-- Make a newtype so that we can easily make a Functor instance
newtype KK b a = KK {getK :: K a b}  

instance Functor (KK b) where
  fmap f (KK (K a)) = KK $ K $ f a 
```
3. 
