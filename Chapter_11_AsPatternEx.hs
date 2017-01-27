import Data.Char

{- 1. This should return True if (and only if) all the values 
in the first list appear in the second list, though they need 
not be contiguous -}

isSubsequenceOf :: (Eq a) => [a] -> [a] -> Bool
isSubsequenceOf [] _ = True
isSubsequenceOf _ [] = False
isSubsequenceOf xs@(x:xss) ys@(y:yss)
  | x == y = isSubsequenceOf xss yss
  | x /= y = isSubsequenceOf xs yss

{- 2. Split a sentence into words, then tuple each word with 
the capitalized form of each. -}

capitalizeWords :: String -> [(String, String)]
capitalizeWords = 
  map pairCpitalizeWord . words
  where
    pairCpitalizeWord :: String -> (String, String)
    pairCpitalizeWord s = (s, capitalizeWord s)

    capitalizeWord :: String -> String
    capitalizeWord = map toUpper 
