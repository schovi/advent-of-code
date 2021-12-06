import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)

main :: IO ()
main = do
  let result = solution 80 $ parseInput ["3,4,3,1,2"]
  print result
  let result = solution 80 $ parseInput $ readLines "inputs/6.input"
  print result
  let result = solution 256 $ parseInput ["3,4,3,1,2"]
  print result
  let result = solution 256 $ parseInput $ readLines "inputs/6.input"
  print result

type Counter = Map Int Int

empty :: Counter
empty = Map.fromList $ map (\day -> (day, 0)) [0..8]

parseInput :: [String] -> Counter
parseInput input = foldl folder empty $ map read $ split ',' $ head input
  where folder counter day = Map.adjust (+1) day counter

zeroDay    = 0
afterSplit = 6
newBorn    = 8

solution :: Int -> Counter -> Int
solution days counter = sum $ Map.elems $ foldl simulate counter [days,days - 1..1]

simulate counter _ = simulate' counter

simulate' :: Counter -> Counter
simulate' counter = Map.alter alterer afterSplit updatedCounter
  where newBornCount   = counter Map.! zeroDay
        updatedCounter = Map.mapKeys (\day -> if day == zeroDay then newBorn else day - 1) counter
        alterer (Just count) = Just (newBornCount + count)
        alterer Nothing      = Just newBornCount
