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

-- 4. Write the swapEitherT helper function for EitherT.
swapEither :: Either e a -> Either a e
swapEither (Left e) = Right e
swapEither (Right a) = Left a

swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT (EitherT ema) = EitherT $ fmap swapEither ema

-- 5. Write the transformer variant of the either catamorphism.
eitherT :: Monad m => (a -> m c) -> (b -> m c) -> EitherT a m b -> m c
eitherT f g (EitherT amb) = do
    ab <- amb
    case ab of 
        Left x -> f x
        Right y -> g y
