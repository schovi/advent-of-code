module Common where

import System.IO.Unsafe ( unsafePerformIO )

readLines :: FilePath -> [String]
readLines file = lines $ unsafePerformIO . readFile $ file

readNumbers :: FilePath -> [Integer]
readNumbers file = map read $ readLines file

split :: Char -> String -> [String]
split c xs = case break (==c) xs of
  (ls, "") -> [ls]
  (ls, _:rs) -> ls : split c rs

takeEvery :: [a] -> Int -> [a]
takeEvery xs n = case drop (n-1) xs of
                      (y:ys) -> y : takeEvery ys n
                      [] -> []
