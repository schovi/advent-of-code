module Common where

import System.IO.Unsafe ( unsafePerformIO )
import Data.Char (digitToInt)

readLines :: FilePath -> [String]
readLines file = lines $ unsafePerformIO . readFile $ file

readBits :: FilePath -> [[Int]]
readBits file = map (map digitToInt) $ readLines file

readWords :: FilePath -> [[String]]
readWords file = map words $ readLines file

readNumbers :: FilePath -> [Integer]
readNumbers file = map read $ readLines file

readInt :: FilePath -> [Int]
readInt file = map read $ readLines file

split :: (Eq a) => a -> [a] -> [[a]]
split c xs = case break (==c) xs of
  (ls, []) -> [ls]
  (ls, _:rs) -> ls : split c rs

splitToTuple :: Eq a => a -> [a] -> ([a], [a])
splitToTuple x xs = (a, b)
  where (a, _ : b) = span (/= x) xs

takeEvery :: [a] -> Int -> [a]
takeEvery xs n = case drop (n-1) xs of
                      (y:ys) -> y : takeEvery ys n
                      [] -> []

unique :: Eq a => [a] -> [a]
unique (x:xs) = if x `elem` xs then unique xs else x : unique xs
unique xs     = xs

-- imap :: (Int -> a -> a) -> [a] -> [a]
imap f = zipWith (curry mapper) [0..]
  where mapper (i, x) = f i x

getByindex :: Int -> [a] -> Maybe a
getByindex x xs = if x >= 0 && x < length xs then Just (xs !! x) else Nothing

isDigit :: Char -> Bool
isDigit = (`elem` ['0'..'9'])

reject f = filter (not . f)
