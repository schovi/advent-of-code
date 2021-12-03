import Common
import Binary
import Data.List (transpose)
import Debug.Trace


main :: IO ()
main = do
  let result = solution $ readBits "inputs/3.test.input"
  print result
  let result = solution $ readBits "inputs/3.input"
  print result
  let result = bonusSolution $ readBits "inputs/3.test.input"
  print result
  let result = bonusSolution $ readBits "inputs/3.input"
  print result

data Counter = Counter {
  zeros :: Int,
  ones :: Int
} deriving Show

solution diagnostics =  gamma * epsilon
  where gamma = fromBin $ map getMostCommon counters
        epsilon = fromBin $ map getLeastCommon counters
        counters = getCounters diagnostics

getCounters diagnostics = map count $ transpose diagnostics
  where count bins = Counter (length $ filter (== 0) bins) (length $ filter (== 1) bins)

getMostCommon :: Counter -> Int
getMostCommon (Counter zeros ones)
  | zeros > ones = 0
  | otherwise = 1

getLeastCommon :: Counter -> Int
getLeastCommon (Counter zeros ones)
  | zeros > ones = 1
  | otherwise = 0

-- Bonus
bonusSolution diagnostics = validOxygen * validCo2
  where validOxygen = getValidDiagnostic diagnostics getMostCommon
        validCo2 = getValidDiagnostic diagnostics getLeastCommon

--getValidDiagnostic :: [Bin] -> [Counter] -> (Counter -> Int) -> Int
getValidDiagnostic diagnostics bitValidator = fromBin number
  where [number] = foldl (folder' bitValidator) diagnostics [0,1..(length (head diagnostics) - 1)]

--folder' :: (Counter -> Int) -> (Int, [Bin]) -> Counter -> (Int, [Bin])
folder' _ [number] _ = [number]
folder' bitValidator diagnostics idx = filter (\d -> (d !! idx) == validBit) diagnostics
  where counter  = foldl counterFolder (Counter 0 0) diagnostics
        counterFolder (Counter zeros ones) diagnostic = if diagnostic !! idx == 0 then Counter (zeros + 1) ones else Counter zeros (ones + 1)
        validBit = bitValidator counter
