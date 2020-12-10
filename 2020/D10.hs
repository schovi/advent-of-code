import Common
import Data.List (sort)
import Data.Map (Map)
import qualified Data.Map as Map
-- cabal install memotrie
import Data.MemoTrie (memo)

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

  print "Bonus Test:"
  let result = bonusSolution $ getJoltageSequence "inputs/10.test.input"
  print result

  print "Bonus Test 2:"
  let result = bonusSolution $ getJoltageSequence "inputs/10.test2.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ getJoltageSequence "inputs/10.input"
  print result

getJoltageSequence file = 0 : adapters ++ [maximum adapters + 3]
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

-- bonus

bonusSolution :: [Int] -> Int
bonusSolution = countVariantsMemo

countVariantsMemo :: [Int] -> Int
countVariantsMemo = memo countVariants

countVariants :: [Int] -> Int
countVariants [_] = 1
countVariants []  = 0
countVariants (current:rest) = sum $ map countVariantsMemo sequences
  where sequences = takePossibleSequences current rest

takePossibleSequences :: Int -> [Int] -> [[Int]]
takePossibleSequences _ [] = []
takePossibleSequences current sequence@(next:rest)
  | diff <= 3 = sequence : takePossibleSequences current rest
  | otherwise = []
  where diff = next - current
