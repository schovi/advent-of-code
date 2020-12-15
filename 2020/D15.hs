
import Common
-- import Data.List (elemIndex)

import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
  print "Test:"
  let result = solution 4 $ readInt "inputs/15.test.input"
  print result

  print "Regular:"
  let result = solution 3 $ readInt "inputs/15.input"
  print result

  print "Bonus test:"
  let result = solution 30000000 $ readInt "inputs/15.test.input"
  print result

  print "Bonus:"
  let result = solution 30000000 $ readInt "inputs/15.input"
  print result

type Input = [Int]
type Cache = Map Int [Int]

type FolderResult = (Int, Cache)

solution :: Int -> Input -> Int
solution max input = fst result
  where result         = foldl folder (last input, inputToMap input) iterations
        iteration      = length input + 1
        iterations     = [iteration..max]

inputToMap :: [Int] -> Cache
inputToMap input = Map.fromList $ imap (\i x -> (x, [i+1])) input

folder :: FolderResult -> Int -> FolderResult
folder (number, cache) iteration = (nextNumber, nextCache)
  where nextNumber = getNext number cache
        nextCache  = Map.alter (adjustItem iteration) nextNumber cache

adjustItem :: a -> Maybe [a] -> Maybe [a]
adjustItem iteration Nothing         = Just [iteration]
adjustItem iteration (Just (last:_)) = Just [iteration, last]
adjustItem _ _                       = error "boom 2"

getNext :: Int -> Cache -> Int
getNext number cache = let value = Map.lookup number cache
                       in case value of (Just [_])           -> 0
                                        (Just (last:prev:_)) -> last - prev
                                        _                    -> error "boom 1"
