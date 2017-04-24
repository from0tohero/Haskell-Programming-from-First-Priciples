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
3. `Flip` from earlier
```haskell
{-# LANGUAGE FlexibleInstances #-}

newtype Flip f a b = 
  Flip (f b a)
  deriving (Eq, Show)

newtype K a b = K a 

instance Functor (Flip K a) where
  fmap f (Flip (K a)) = Flip $ K (f a)
```
4. 
```haskell
data EvilGoateeConst a b = GoatyConst b

instance Functor (EvilGoateeConst a) where
  fmap f (GoatyConst b) = GoatyConst $ f b
```
5. Do you need something extra to make the instance work?
```haskell
data LiftItOut f a = LiftItOut (f a)

instance Functor f => Functor (LiftItOut f) where
  fmap f (LiftItOut fa) = LiftItOut $ fmap f fa
```
6. 
```haskell
data Parappa f g a = DaWrappa (f a) (g a)

instance (Functor f, Functor g) => Functor (Parappa f g) where
  fmap f (DaWrappa fa ga) = DaWrappa (fmap f fa) (fmap f ga)
```
7. Don’t ask for more typeclass instances than you need. You can let GHC tell you what to do.
```haskell
data IgnoreOne f g a b = IgnoringSomething (f a) (g b)

instance Functor g => Functor (IgnoreOne f g a) where
  fmap f (IgnoringSomething fa gb) = IgnoringSomething fa $ fmap f gb
```
8. 
```haskell
data Notorious g o a t = Notorious (g o) (g a) (g t)

instance Functor g => Functor (Notorious g o a) where
  fmap f (Notorious go ga gt) = Notorious go ga $ fmap f gt
```
9. You’ll need to use recursion.
```haskell
data List a =
    Nil
  | Cons a (List a)
  
instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a as) = Cons (f a) (fmap f as)
```
10. A tree of goats forms a Goat-Lord, fearsome poly-creature.
```haskell
data GoatLord a =
    NoGoat
  | OneGoat a
  | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
  
instance Functor GoatLord where
  fmap _ NoGoat = NoGoat
  fmap f (OneGoat x) = OneGoat $ f x
  fmap f (MoreGoats ga ga' ga'') = MoreGoats (fmap f ga) (fmap f ga') (fmap f ga'')
```
11. 
```haskell
data TalkToMe a = 
    Halt
  | Print String a
  | Read (String -> a)

instance Functor TalkToMe where
  fmap _ Halt = Halt
  fmap f (Print s a) = Print s $ f a 
  fmap f (Read sa) = Read $ fmap f sa
```
