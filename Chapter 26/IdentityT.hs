newtype IdentityT m a = IdentityT { runIdentityT :: m a }
  deriving (Eq, Show)

instance Functor f => Functor (IdentityT f) where
  fmap f (IdentityT fa) = IdentityT $ fmap f fa

instance Applicative f => Applicative (IdentityT f) where
  pure = IdentityT . pure 
  IdentityT mf <*> IdentityT mx = IdentityT $ mf <*> mx

instance Monad m => Monad (IdentityT m) where
  return = pure
  IdentityT ma >>= f = 
    IdentityT $ ma >>= (runIdentityT . f)
