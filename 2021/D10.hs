import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.Set as Set
import Data.Set (Set)

import qualified Data.List as List

import Data.Maybe (mapMaybe)
import Control.Concurrent.STM (check)

main :: IO ()
main = do
  let result = solution $ readLines "inputs/10.test.input"
  print result
  let result = solution $ readLines "inputs/10.input"
  print result
  let result = bonusSolution $ readLines "inputs/10.test.input"
  print result
  let result = bonusSolution $ readLines "inputs/10.input"
  print result

openingChars = Set.fromList "([{<"
closingChars = Set.fromList ")]}>"

pairs = Map.fromList [('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')]

-- Solution

solution = sum . map assignPoint . mapMaybe checkLine

assignPoint :: Char -> Int
assignPoint ')' = 3
assignPoint ']' = 57
assignPoint '}' = 1197
assignPoint '>' = 25137
assignPoint _ = error "no no no"

checkLine :: String -> Maybe Char
checkLine line = checkLine' line []

checkLine' :: String -> String -> Maybe Char
checkLine' (char:rest) closings
  | isOpening || null closings = checkLine' rest (pairs Map.! char : closings)
  | isClosing && char == closingChar = checkLine' rest nextClosings
  | otherwise = Just char
  where isOpening = Set.member char openingChars
        isClosing = Set.member char closingChars
        (closingChar:nextClosings) = closings

checkLine' _ _ = Nothing

-- Bonus

bonusSolution lines = results !! ((length results - 1) `div` 2)
  where results = List.sort . map (foldl calculator 0 . map bonusAssignPoint) . mapMaybe findClosingChars $ lines
        calculator sum value = sum * 5 + value


findClosingChars :: String -> Maybe String
findClosingChars line = findClosingChars' line []

findClosingChars' :: String -> String -> Maybe String

findClosingChars' [] closings = Just closings

findClosingChars' (char:rest) closings
  | isOpening || null closings = findClosingChars' rest (pairs Map.! char : closings)
  | isClosing && char == closingChar = findClosingChars' rest nextClosings
  | otherwise = Nothing
  where isOpening = Set.member char openingChars
        isClosing = Set.member char closingChars
        (closingChar:nextClosings) = closings

bonusAssignPoint :: Char -> Int
bonusAssignPoint ')' = 1
bonusAssignPoint ']' = 2
bonusAssignPoint '}' = 3
bonusAssignPoint '>' = 4
bonusAssignPoint _ = error "no no no"
