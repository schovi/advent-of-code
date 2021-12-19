{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

import Common
import Debug.Trace
import Data.Char (digitToInt)

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.List as List

import Data.Maybe (mapMaybe, fromJust, fromMaybe)

main :: IO ()
main = do
  let result = solution $ parseInput $ readLines "inputs/18.test.input"
  print result
  -- let result = solution $ parseInput "inputs/18.input"
  -- print result
  -- let result = solution $ parseInput "inputs/18.test.input"
  -- print result
  -- let result = solution $ parseInput "inputs/18.input"
  -- print result

data SnailNumber = Regular Int
                 | Pair SnailNumber SnailNumber
                 deriving (Show, Eq)

solution = foldl1 reduce

reduce left right = reduce' $ Pair left right

reduce' snailNumber = case (splittedSnailNumber, explodedSnailNumber) of
  (Nothing, Nothing) -> snailNumber
  (_, Just snailNumber') -> reduce' snailNumber'
  where splittedSnailNumber = splitNumber snailNumber
        explodedSnailNumber = explode (fromMaybe snailNumber splittedSnailNumber)

splited snailNumber = fromMaybe (Regular (-1)) $ splitNumber snailNumber

splitNumber :: SnailNumber -> Maybe SnailNumber
splitNumber (Regular value)
  | value > 9 = Just $ Pair left right
  | otherwise = Nothing
  where left = Regular (value `div` 2)
        right = Regular ((value `mod` 2) + (value `div` 2))

splitNumber pair@(Pair left right) = case (splitNumber left, splitNumber right) of
  (Just left', _)  -> Just $ Pair left' right
  (_, Just right') -> Just $ Pair left right'
  _                -> Nothing

exploded snailNumber = fromMaybe (Regular (-1)) $ explode snailNumber

explode snailNumber = case explode' 1 snailNumber of Exploded snailNumber' -> Just snailNumber'
                                                     OverflowLeft _ snailNumber' -> Just snailNumber'
                                                     OverflowRight _ snailNumber' -> Just snailNumber'
                                                     _ -> Nothing

data Explode = OverflowLeft Int SnailNumber
             | OverflowRight Int SnailNumber
             | Overflow Int Int
             | Exploded SnailNumber
             | ExplodedNothing
             | NotExploded SnailNumber
             deriving (Show, Eq)

explode' :: Int -> SnailNumber -> Explode
explode' _ r@(Regular _) = ExplodedNothing

explode' lvl (Pair (Regular left) (Regular right))
  | lvl > 4 = Overflow left right
  | otherwise = ExplodedNothing

-- explode' lvl p@(Pair (Pair (Regular left) (Regular right)) (Regular secondRight))
--   | lvl >= 4 = OverflowLeft left $ Pair (Regular 0) (Regular (right+secondRight))
--   | otherwise = ExplodedNothing

-- explode' lvl p@(Pair (Regular secondLeft) (Pair (Regular left) (Regular right)))
--   | lvl >= 4 = OverflowRight right $ Pair (Regular (secondLeft+left)) (Regular 0)
--   | otherwise = ExplodedNothing

-- -- Hack how to not overwrite last explode' definiteion
-- explode' lvl p@(Pair prevPair@(Pair _ _) (Pair (Regular left) (Regular right)))
--   | lvl >= 4 = OverflowRight right $ addOverflowToRight left prevPair
--   | otherwise = ExplodedNothing

-- trace ("lvl " ++ show (lvl+1) ++ "\nleft: " ++ stringifySnailNumber left ++ "\nright " ++ stringifySnailNumber right ++ "\n" )
explode' lvl (Pair left right) = case trace (traceExplode lvl left right explodedLeft explodedRight) (explodedLeft , explodedRight) of
  (Overflow oLeft oRight, _)             -> case right of (Regular regularRight) -> OverflowRight oLeft (Pair (Regular 0) (Regular (oRight+regularRight)))
                                                          (Pair _ _)             -> OverflowRight oLeft (addOverflowToLeft oRight right)
  (_, Overflow oLeft oRight)             -> case left of (Regular regularLeft) -> OverflowLeft oRight (Pair (Regular (oLeft+regularLeft)) (Regular 0))
                                                         (Pair _ _)            -> OverflowLeft oRight (addOverflowToRight oLeft left)
  (_, o@(OverflowLeft overflow right')) -> Exploded $ Pair (addOverflowToRight overflow left) right'
  (o@(OverflowRight overflow left'), _) -> Exploded $ Pair left' (addOverflowToLeft overflow right)
  (OverflowLeft overflow left', _)      -> OverflowLeft overflow $ Pair left' right
  (_, OverflowRight overflow right')    -> OverflowRight overflow $ Pair left right'
  (Exploded left', _)                   -> Exploded $ Pair left' right
  (_, Exploded right')                  -> Exploded $ Pair left right'
  _ -> NotExploded $ Pair left right
  where explodedLeft = explode' (lvl+1) left
        explodedRight = explode' (lvl+1) right


traceExplode lvl left right eLeft eRight =
    "lvl " ++ show (lvl+1) ++ "\nleft: " ++ stringifySnailNumber left ++ " -> " ++ show eLeft ++ "\nright " ++ stringifySnailNumber right ++ " -> " ++ show eRight ++ "\n"

addOverflowToRight overflow (Regular num) = Regular (num + overflow)
addOverflowToRight overflow (Pair left right) = Pair left (addOverflowToRight overflow right)

addOverflowToLeft overflow (Regular num) = Regular (num + overflow)
addOverflowToLeft overflow (Pair left right) = Pair (addOverflowToLeft overflow left) right

-- Parsing

printSnailNumber = putStrLn.stringifySnailNumber

stringifySnailNumber (Regular num) = show num
stringifySnailNumber (Pair left right) = "[" ++ stringifySnailNumber left  ++ "," ++ stringifySnailNumber right ++ "]"

data Token = Open | Close | Value Int deriving (Show)


parseInput = map parseSnailNumber

parseSnailNumber = fst.takeTree.tokenize

takeTree ((Value number):rest) = (Regular number, rest)

takeTree tokens@(Open:_) = (Pair left right, rest)
  where (innerTokens, rest) = takeUntilClosed 0 tokens
        (left, rest') = takeTree innerTokens
        (right, _) = takeTree rest'

takeUntilClosed level (Open:rest) = (if level == 0 then tokens else Open : tokens, rest')
  where (tokens, rest') = takeUntilClosed (level+1) rest

takeUntilClosed 1 (Close:rest) = ([], rest)

takeUntilClosed level (Close:rest) = (Close : tokens, rest')
  where (tokens, rest') = takeUntilClosed (level-1) rest

takeUntilClosed level (value:rest) = (value: tokens, rest')
  where (tokens, rest') = takeUntilClosed level rest

tokenize [] = []
tokenize ('[':rest) = Open : tokenize rest
tokenize (']':rest) = Close : tokenize rest
tokenize (',':rest) = tokenize rest
tokenize line = Value (read number) : tokenize rest
  where (number, rest) = parseNumber line

parseNumber :: String -> (String, String)
parseNumber [] = ([], [])
parseNumber line@(char:rest)
  | isDigit char = (char : rawNumber, rest')
  | otherwise = ([], line)
  where result@(rawNumber, rest') = parseNumber rest
