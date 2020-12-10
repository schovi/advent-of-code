import Common
import Data.List (sort)
import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
  print "Test:"
  let result = solution $ getJoltageSequence "inputs/10.test.input"
  print result

  print "Test 2:"
  let result = solution $ getJoltageSequence "inputs/10.test2.input"
  print result

  print "Regular:"
  let result = solution $ getJoltageSequence "inputs/10.input"
  print result

  -- print "Bonus Test:"
  -- let result = bonusSolution $ readInt "inputs/10.test.input"
  -- print result

  -- print "Bonus:"
  -- let result = bonusSolution $ readInt "inputs/10.input"
  -- print result

getJoltageSequence file = 0 : adapters ++ [maximum adapters]
  where adapters = sort $ readInt file

type Diffs = Map Int Int
solution :: [Int] -> Int
solution joltageSequence = case result of (Just one, Just three) -> one * three
                                       _                      -> error "boom"
  where diffs  = findJoltageDiffs Map.empty joltageSequence
        result = (Map.lookup 1 diffs, Map.lookup 3 diffs)

findJoltageDiffs :: Diffs -> [Int] -> Diffs
findJoltageDiffs diffs (current:next:adapters) = findJoltageDiffs newDiffs $ next : adapters
  where diff           = next - current
        newDiffs       = Map.alter updateDiff diff diffs

findJoltageDiffs diffs _ = diffs

updateDiff :: Maybe Int -> Maybe Int
updateDiff val = case val of Just value -> Just (value + 1)
                             Nothing    -> Just 1
