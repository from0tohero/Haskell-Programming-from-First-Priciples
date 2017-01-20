{-
    Chapter 10. Data Structure Origami
    Page 367
    Database Processing
-}

import Data.Time

data DatabaseItem = DbString String
                  | DbNumber Integer
                  | DbDate UTCTime
                  deriving (Eq, Ord, Show)

theDatabase :: [DatabaseItem]
theDatabase =
    [ DbDate (UTCTime
                (fromGregorian 1911 5 1)
                (secondsToDiffTime 34123))
    , DbNumber 9001
    , DbString "Hello, world!"
    , DbDate (UTCTime
                (fromGregorian 1921 5 1)
                (secondsToDiffTime 34123))
    ]

-- 1. Write a function that filters for DbDate values and returns a list 
-- of the UTCTime values inside them.
filterDbDate :: [DatabaseItem] -> [UTCTime]
filterDbDate = foldr converter []
                    where converter :: DatabaseItem -> [UTCTime] -> [UTCTime]
                          converter (DbDate date) ds = date : ds
                          converter _             ds = ds

-- 2. Write a function that filters for DbNumber values and returns a list
-- of the Integer values inside them.
filterDbNumber :: [DatabaseItem] -> [Integer]
filterDbNumber = foldr converter []
                     where converter :: DatabaseItem -> [Integer] -> [Integer]
                           converter (DbNumber num) ds = num : ds
                           converter _              ds = ds

-- 3. Write a function that gets the most recent date.
mostRecent :: [DatabaseItem] -> UTCTime
mostRecent = foldr recent (UTCTime (fromGregorian 1000 1 1) (secondsToDiffTime 34123))
                    where recent :: DatabaseItem -> UTCTime -> UTCTime
                          recent (DbDate date) res = if date > res then date else res
                          recent _             res = res

-- 4. Write a function that sums all of the DbNumber values.
sumDb :: [DatabaseItem] -> Integer
sumDb = foldr sumDb' 0
            where sumDb' :: DatabaseItem -> Integer -> Integer
                  sumDb' (DbNumber num) acc = num + acc
                  sumDb' _              acc = acc

-- 5. Write a function that gets the average of the DbNumber values.
avgDb :: [DatabaseItem] -> Double
avgDb ds = (fromIntegral $ sumDb ds) / (fromIntegral $ countNums ds)
                where countNums :: [DatabaseItem] -> Integer
                      countNums = foldr countNums' 0
                                    where countNums' :: DatabaseItem -> Integer -> Integer
                                          countNums' (DbNumber _) acc = acc + 1
                                          countNums' _            acc = acc
