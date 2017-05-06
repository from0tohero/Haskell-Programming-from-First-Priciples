newtype MaybeT m a =
    MaybeT { runMaybeT :: m (Maybe a) }

instance Functor m => Functor (MaybeT m) where
    fmap f (MaybeT ma) = MaybeT $ (fmap . fmap) f ma

instance Applicative m => Applicative (MaybeT m) where
    pure x = MaybeT $ pure $ pure x
    (<*>) (MaybeT mf) (MaybeT ma) =
        MaybeT $ (<*>) <$> mf <*> ma

instance Monad m => Monad (MaybeT m) where
    return = pure
    MaybeT mma >>= f = MaybeT $ do
        ma <- mma
        case ma of
            Nothing -> return Nothing
            Just x -> runMaybeT $ f x
