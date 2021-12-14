{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Common
import Debug.Trace
import Data.Char (digitToInt)

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.Set as Set
import Data.Set (Set)

import qualified Data.List as List

import Data.Maybe (mapMaybe)

main :: IO ()
main = do
  let result = solution 10 $ readManual "inputs/14.test.input"
  print result
  print "=========="
  let result = solution 10 $ readManual "inputs/14.input"
  print result
  print "=========="
  let result = solution 40 $ readManual "inputs/14.test.input"
  print result
  print "=========="
  let result = solution 40 $ readManual "inputs/14.input"
  print result

type PolymerTemplate = Map String Int
type PairInsertion = (String, Char)
type PairInsertionRules = Map String Char

type Manual = (PolymerTemplate, PairInsertionRules)

readManual :: String -> Manual
readManual path = (template, rules)
  where template = populateTemplate rawTemplate
        rules = readRules rawRules
        (rawTemplate:_:rawRules) = readLines path

populateTemplate :: String -> PolymerTemplate
populateTemplate [] = error "no no no"
populateTemplate [_] = Map.empty
populateTemplate (x:y:rawTemplate) = Map.insertWith (+) [x,y] 1 (populateTemplate (y:rawTemplate))

readRules :: [String] -> PairInsertionRules
readRules lines = Map.fromList $ map (parseRule . words) lines
  where parseRule (pair:_:polymer:_) = (pair, head polymer)

-- Solution
solution steps (template, rules) =  (docount.Map.toList) result
  --(fst . last) grouped - (fst . head) grouped
  where --grouped = List.sort $ map (\(k,v) -> (v,k)) $ Map.toList result
        result = foldl folder template [1..steps]
        folder template' _ = step rules template'

docount = foldr myins Map.empty
    where myins (p,n) m = Map.insertWith (+) (p!!0) n (Map.insertWith (+) (p!!1) n m)

step :: PairInsertionRules -> PolymerTemplate -> PolymerTemplate
step rules template = foldl (splitPair rules) Map.empty (Map.toList template)

splitPair :: PairInsertionRules -> PolymerTemplate -> (String, Int) -> PolymerTemplate
splitPair rules template (pair@[p1,p2], count) = Map.insertWith (+) [polymerToInsert, p2] count $ Map.insertWith (+) [p1,polymerToInsert] count template
  where polymerToInsert = rules Map.! pair
