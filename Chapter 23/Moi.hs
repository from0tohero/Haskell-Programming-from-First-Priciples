newtype Moi s a = Moi { runMoi :: s -> (a, s) }

instance Functor (Moi s) where
  fmap f (Moi g) = Moi $ \s -> 
    let (a, newState) = g s
    in (f a, newState)
                               
instance Applicative (Moi s) where
  pure a = Moi $ \s -> (a, s)
  Moi f <*> Moi g = Moi $ \s ->
    let (fa, _) = f s
        (ga, newState) = g s
    in (fa ga, newState)

instance Monad (Moi s) where
  return = pure
  Moi g >>= f = Moi $ \s ->
    let (a, s') = g s
        Moi h = f a
    in h s'

get :: Moi s s
get = Moi $ \x -> (x, x)

put :: s -> Moi s ()
put s = Moi $ \s' -> ((), s)

exec :: Moi s a -> s  -> s
exec (Moi sa) s = snd $ sa s

eval :: Moi s a -> s -> a
eval (Moi sa) s = fst $ sa s

modify :: (s -> s) -> Moi s ()
modify f = Moi $ \s -> ((), f s)
