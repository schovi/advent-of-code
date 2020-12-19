import Common

import Data.List (filter)

import Data.Set (Set)
import qualified Data.Set as Set

import Data.Map (Map)
import qualified Data.Map as Map

import Data.MemoTrie (memo)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readInput "inputs/19.test.input"
  print result

  -- print "Regular:"
  -- let result = solution $ readInput "inputs/19.input"
  -- print result

  print "Test 2 unaffected:"
  let result = solution $ readInput "inputs/19.test2.input"
  print result

  print "Test 2 replaced:"
  let result = solution $ readInput "inputs/19.test2.replaced.input"
  print result

  -- print "Bonus:"
  -- let result = bonusSolution $ readLines "inputs/19.input"
  -- print result

type RawRules = [String]
type IndexedRules = Map Int String
type Rules = Set String
type Message = String

readInput :: String -> (Rules, [Message])
readInput file = (rules, messages)
  where (rawRules, messages) = splitToTuple "" $ readLines file
        rules                = generateRules rawRules 0
        -- rules = foldl (rulesFolder rawRules) Set.empty [0..(length rawRules - 1)]

indexedRules :: RawRules -> IndexedRules
indexedRules = memo indexedRules'

indexedRules' :: RawRules -> IndexedRules
indexedRules' rawRules = Map.fromList $ map ruleWithIndex rawRules
  where ruleWithIndex rawRule = (read idx, rule)
          where (idx, rule) = splitToTuple ':' rawRule

rulesFolder :: RawRules -> Rules -> Int -> Rules
rulesFolder rawRules rules ruleIdx = Set.union rules $ generateRules rawRules ruleIdx

generateRules :: RawRules -> Int -> Rules
generateRules rawRules ruleIdx = Set.fromList $ findRuleMemo rawRules ruleIdx

findRuleMemo :: RawRules -> Int -> [String]
findRuleMemo = memo findRule

findRule :: RawRules -> Int -> [String]
findRule rawRules ruleIdx = findRule' rawRules ruleIdx $ Map.lookup ruleIdx (indexedRules rawRules)

findRule' :: RawRules -> Int -> Maybe String -> [String]
findRule' rawRules ruleIdx Nothing = error "boom"
findRule' rawRules ruleIdx (Just rawRule) | isLetter  = [[letter]]
                                          | otherwise = patterns
  where letter        = rawRule !! 2
        isLetter      = length rawRule > 2 && letter `elem` ['a'..'z']
        orPatterns    = map (map read . words) $ split '|' rawRule :: [[Int]]
        patterns      = concatMap buildPattern orPatterns
        finder        = findRuleMemo rawRules
        buildPattern ptrns = foldl combinePatterns [[]] $ map finder ptrns

combinePatterns :: [String] -> [String] -> [String]
combinePatterns a b = [x ++ y | x <- a, y <- b]

solution (rules, messages) = length $ filter (`Set.member` rules) messages
