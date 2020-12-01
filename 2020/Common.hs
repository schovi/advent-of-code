module Common where

import System.IO.Unsafe

readInput file = lines $ unsafePerformIO . readFile $ file

readNumbers :: FilePath -> [Integer]
readNumbers file = map read $ readInput file
