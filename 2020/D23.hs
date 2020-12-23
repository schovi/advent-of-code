-- {-# language Strict #-}
import Common
import Data.Char (digitToInt)
import Data.List ((\\), filter)
import Data.Maybe (fromJust)
import Data.Ord

import Data.IntMap (IntMap)
import qualified Data.IntMap as IntMap

import Debug.Trace

main :: IO ()
main = do
  let result = solution $ toState (toDigits "389125467")
  print result

  let result = solution $ toState (toDigits "398254716")
  print result

  let result = bonusSolution $ toState $ toDigits "389125467" ++ [10..1000000]
  print result

  let result = bonusSolution $ toState $ toDigits "398254716" ++ [10..1000000]
  print result


toDigits = map digitToInt

prepareMap cups = IntMap.fromList $ zip cups (tail cups ++ [head cups])

type Cups = IntMap Int
data State = State { cups :: Cups,
                     current :: Int,
                     max :: Int
                   } deriving (Show)

toState cups = State (prepareMap cups) (head cups) (maximum cups)

-- Solution
solution :: State -> String
solution state = concatMap show sequence
  where cups      = play 100 state
        sequence  = takeWhile (/= 1) $ iterate (cups IntMap.!) (cups IntMap.! 1)

game :: State -> State
game state@(State cups current max) = State newCups nextAfterCurrent max
  where newCups = foldl (\c (k, v) -> IntMap.insert k v c) cups cupsToUpdate
        cupsToUpdate = [(current, nextAfterCurrent), (appendAfter, nextA), (nextC, prepentBefore)]
        nextA = cups IntMap.! current
        nextB = cups IntMap.! nextA
        nextC = cups IntMap.! nextB
        nextAfterCurrent = cups IntMap.! nextC
        appendAfter      = findConnectAfter state [nextA, nextB, nextC]
        prepentBefore    = cups IntMap.! appendAfter

findConnectAfter :: State -> [Int] -> Int
findConnectAfter (State _ current max) three = lookingFor
  where reachedMinimum = current <= 4 && (current - 1) == length (filter (< current) three)
        lookingFor     = if reachedMinimum then findFirst max three
                                           else findFirst (current - 1) three

findFirst toFind three = if found then findFirst (toFind - 1) three
                                  else toFind
  where found = toFind `elem` three

bonusSolution :: State -> Int
bonusSolution state = first * second
  where result = play 10000000 state
        first  = result IntMap.! 1
        second = result IntMap.! first

play :: Int -> State -> Cups
play times state = cups
  where (State cups _ _) = iterate game state !! times
