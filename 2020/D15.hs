
import Common
import Data.List (find)

import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
  print "Test:"
  let result = solution 2020 $ readInt "inputs/15.test.input"
  print result

  print "Regular:"
  let result = solution 2020 $ readInt "inputs/15.input"
  print result

  print "Bonus test:"
  let result = solution 30000000 $ readInt "inputs/15.test.input"
  print result

  print "Bonus:"
  let result = solution 30000000 $ readInt "inputs/15.input"
  print result

type Input = [Int]
type Cache = Map Int Int

type State = (Cache, Int, Int)

solution :: Int -> Input -> Int
solution iterations input = case result of Just (_, number, _) -> number
                                           Nothing             -> error "boom"
  where result = find predicate $ iterate nextState initialState
        initialState   = (inputToState input, last input, length input + 1)
        predicate (_, _, iteration) = iteration > iterations

inputToState :: [Int] -> Cache
inputToState input = Map.fromList $ zip input [1..]

nextState :: State -> State
nextState (cache, number, iteration) = (nextCache, nextNumber, iteration + 1)
  where nextNumber = case Map.lookup number cache of (Just value) -> (iteration - 1) - value
                                                     Nothing      -> 0
        nextCache  = Map.insert number (iteration - 1) cache

getNext :: Int -> Int -> Cache -> Int
getNext number iteration cache = let value = Map.lookup number cache
                                 in case value of (Just value) -> (iteration - 1) - value
                                                  Nothing      -> 0
