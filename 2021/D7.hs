import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)
import Text.Parsec (parse)

main :: IO ()
main = do
  let result = solution $ parseInput $ readLines "inputs/7.test.input"
  print result
  let result = solution $ parseInput $ readLines "inputs/7.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/7.test.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/7.input"
  print result

parseInput :: [String] -> [Int]
parseInput [input] = map read $ split ',' input
parseInput _ = error "Expected exactly one input"

-- Solution

solution :: [Int] -> Int
solution crabsPositions = minimum $ map (compute crabsPositions) [minPosition..maxPosition]
  where minPosition = minimum crabsPositions
        maxPosition = maximum crabsPositions

compute :: [Int] -> Int -> Int
compute crabsPositions position = sum $ map (compute' position) crabsPositions

compute' position crabPosition = if position < crabPosition then crabPosition - position
                                                            else position - crabPosition


-- Bonus

bonusSolution :: [Int] -> Int
bonusSolution crabsPositions = minimum $ map (bonusCompute crabsPositions) [minPosition..maxPosition]
  where minPosition = minimum crabsPositions
        maxPosition = maximum crabsPositions

bonusCompute :: [Int] -> Int -> Int
bonusCompute crabsPositions position = sum $ map (bonusCompute' position) crabsPositions

bonusCompute' position crabPosition = sum [0..steps]
  where steps = if position < crabPosition then crabPosition - position
                                           else position - crabPosition
