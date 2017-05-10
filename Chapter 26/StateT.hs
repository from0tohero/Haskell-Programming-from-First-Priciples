newtype StateT s m a = StateT { runStateT :: s -> m (a, s) }

instance Functor m => Functor (StateT s m) where
    fmap f (StateT smas) = StateT $ \s ->
        let mas = smas s            -- type: m (a, s)
            mb = fmap (f . fst) mas -- type: m (b, s)
        in fmap (\b -> (b, s)) mb   -- type: m (b, s)

instance Applicative m => Applicative (StateT s m) where
    pure a = StateT $ \s -> pure (a, s)
    -- smfs has type s -> m ((a -> b), s)
    StateT smfs <*> StateT smas = StateT $ \s ->
        let mfs = smfs s    -- type: m ((a -> b), s)
            mf  = fmap fst mfs -- type: m b
            mas = smas s       -- type: m (a, s)
            ma  = fmap fst mas -- type: m a
            ms  = fmap snd mas -- type: m s
        in (,) <$> (mf <*> ma) <*> ms  -- type: (,) -> m a -> m s -> m (a, s)

instance Monad m => Monad (StateT s m) where
    return = pure
    (StateT smas) >>= f = StateT $ \s -> do
       (a, s') <- smas s  
       let smbs = runStateT $ f a -- f a :: StateT { s -> m (b, s) }
       smbs s' 
