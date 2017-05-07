newtype EitherT e m a = EitherT { runEitherT :: m (Either e a) }

instance Functor m => Functor (EitherT e m) where
    fmap f (EitherT ema) = EitherT $ (fmap . fmap) f ema

instance Applicative m => Applicative (EitherT e m) where
    pure x = EitherT $ pure $ pure x
    EitherT mf <*> EitherT ma =
        EitherT $ fmap (<*>) mf <*> ma

instance Monad m => Monad (EitherT e m) where
    return = pure
    EitherT mea >>= f = EitherT $ do
        ea <- mea
        case ea of
            Left e -> return (Left e)
            Right x -> runEitherT $ f x
