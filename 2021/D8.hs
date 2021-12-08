{-# LANGUAGE TupleSections #-}

import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)
import Data.List (sort)
import Data.Binary (decode)

main :: IO ()
main = do
  let result = solution $ parseInput $ readLines "inputs/8.test.input"
  print result
  let result = solution $ parseInput $ readLines "inputs/8.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/8.test.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/8.input"
  print result

type NoteLine = ([String], [String])
type Input = [NoteLine]

parseInput :: [String] -> Input
parseInput = map parseLine

parseLine :: String -> NoteLine
parseLine line = case (split "|" . map sort . words) line of (a:b:_) -> (a,b)
                                                             _ -> error "no no no"

-- Segments Count -> Digit
simpleDigits = Map.fromList [(2, 1),(3, 7),(4, 4), (7, 8)]

-- Solution
solution :: Input -> Int
solution = length . concatMap findSimpleSegments

findSimpleSegments :: NoteLine -> [String]
findSimpleSegments (_, digits) = filter isSimpleDigit digits

isSimpleDigit :: String -> Bool
isSimpleDigit digit =  Map.member (length digit) simpleDigits

-- Bonus
-- bonusSolution :: Input -> Int
bonusSolution = sum . map decodeLine

digitSegments = Map.fromList [
                                ("abcefg", 0)
                              , ("cf", 1)
                              , ("acdeg", 2)
                              , ("acdfg", 3)
                              , ("bcdf", 4)
                              , ("abdfg", 5)
                              , ("abdefg", 6)
                              , ("acf", 7)
                              , ("abcdefg", 8)
                              , ("abcdfg", 9)
                             ]

emptySegments = Map.fromList (map (, []) ['a'..'g'])

originalMapping = patternsToSegmentsMap $ Map.keys digitSegments

segmentToDigits = Map.foldrWithKey mapFolder emptySegments digitSegments
  where mapFolder segments digit newMap = foldl (folder digit) newMap segments
        folder digit newMap segment = Map.adjust (digit:) segment newMap

decodeLine :: NoteLine -> Int
decodeLine (patterns, digits) = read $ map (\digit -> head . show $ digitSegments Map.! (mapping Map.! digit)) digits
  where mapping = decodePatterns patterns

decodePatterns patterns = Map.fromList $ map (\pattern -> (pattern, sort $ toOriginalMapping pattern)) patterns
  where toOriginalMapping pattern = map (charsMapping Map.!) pattern
        charsMapping = Map.fromList $ map (\(mapPattern, char) -> (char, originalMapping Map.! mapPattern)) mapping
        mapping = Map.toList $ patternsToSegmentsMap patterns

patternsToSegmentsMap patterns = patternsMapping
  where patternsMapping = Map.fromList $ map (\(k, v) -> (v, k)) $ Map.toList patterned
        patterned = Map.map (sort . map length) grouped
        grouped = foldl patternToSegmentsMap emptySegments patterns

patternToSegmentsMap segments pattern = foldl (segmentFolder pattern) segments pattern
  where segmentFolder pattern segments segment = Map.adjust (pattern:) segment segments
