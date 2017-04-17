import Control.Monad (join)

data Cow = Cow {
    name   :: String
  , age    :: Int
  , weight :: Int
  } deriving (Eq, Show)

noEmpty :: String -> Maybe String
noEmpty ""  = Nothing
noEmpty str = Just str

noNegative :: Int -> Maybe Int
noNegative n = if n >= 0 then Just n
                         else Nothing

-- if Cow's name is Bess, must be under 500
weightCheck :: Cow -> Maybe Cow
weightCheck c =
  let w = weight c
      n = name c
  in if n == "Bess" && w > 499
    then Nothing
    else Just c

mkSphericalCow :: String -> Int -> Int -> Maybe Cow
{--
-- Without DO
mkSphericalCow name' age' weight' =
  case noEmpty name' of
    Nothing -> Nothing
    Just nammy ->
      case noNegative age' of
        Nothing -> Nothing
        Just agey -> 
          case noNegative weight' of
            Nothing -> Nothing
            Just weighty -> weightCheck (Cow nammy agey weighty)
            --}
{--
-- with DO
mkSphericalCow name' age' weight' = do
  nammy <- noEmpty name'
  agey  <- noNegative age'
  weighty <- noNegative weight'
  weightCheck (Cow nammy agey weighty)
--}
{--
-- use >>=
mkSphericalCow name' age' weight' =
  noEmpty name' >>=
  \nammy -> 
    noNegative age' >>=
      \agey ->
        noNegative weight' >>=
          \weighty ->
            weightCheck (Cow nammy agey weighty)
--}
{--
-- Applicative + Monad
mkSphericalCow name' age' weight' = do
  cow <- Cow <$> noEmpty name' <*> noNegative age' <*> noNegative weight'
  weightCheck cow 
--}
-- Applicative + Monad Join
mkSphericalCow name' age' weight' =
  join $ fmap weightCheck cow
    where cow = Cow <$> noEmpty name' <*> noNegative age' <*> noNegative weight'
