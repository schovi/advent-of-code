import Common
import qualified Data.Map as Map
import Data.Map (Map)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ parseLuggages $ readWords "inputs/7.test.input"
  print result

  print "Regular:"
  let result = solution $ parseLuggages $ readWords "inputs/7.input"
  print result

  print "Bonus Test:"
  let result = bonusSolution $ parseLuggages $ readWords "inputs/7.test.input"
  print result

  print "Bonus Test 2:"
  let result = bonusSolution $ parseLuggages $ readWords "inputs/7.test2.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ parseLuggages $ readWords "inputs/7.input"
  print result

-- Parsing
type BagCount = (Int, String)
type Definitions = Map String [BagCount]

parseLuggages :: [[String]] -> Definitions
parseLuggages lines = Map.fromList $ map parseLuggage lines

parseLuggage :: [String] -> (String, [BagCount])
parseLuggage (first:second:_:_:"no":"other":"bags.":_) = (first ++ " " ++ second, [])
parseLuggage (first:second:_:_:rest) = (first ++ " " ++ second, parseContainingLuggages rest)
parseLuggage _ = ("Fake", []) -- The pattern matching must be exhaustive, so just fallback :)

parseContainingLuggages :: [String] -> [BagCount]
parseContainingLuggages (count:first:second:splitter:next)
  | splitter `elem` ["bag,", "bags,"] = bag : parseContainingLuggages next
  | splitter `elem` ["bag.", "bags."] = [bag]
  | otherwise = []
  where bag = (read count, first ++ " " ++ second)

-- Solution

theBag :: String
theBag = "shiny gold"

solution :: Definitions -> Int
solution definitions = sum $ map (traverseLuggages withoutTheBag) $ Map.keys withoutTheBag
  where withoutTheBag = Map.delete theBag definitions

traverseLuggages :: Definitions -> String -> Int
traverseLuggages _ "shiny gold"  = 1
traverseLuggages definitions bag = if containsResult > 0 then 1 else 0
  where containsResult = case Map.lookup bag definitions of
                          Just contains -> sum $ map (\(_, name) -> traverseLuggages definitions name) contains
                          Nothing   -> 0

-- Bonus

bonusSolution :: Definitions -> Int
bonusSolution definitions = bonusTraverseLuggages definitions theBag

bonusTraverseLuggages :: Definitions -> String -> Int
bonusTraverseLuggages definitions name = case Map.lookup name definitions of
                                          Just contains -> sum $ map calculateContains contains
                                          Nothing       -> 1
  where calculateContains (count, name) = count + count * bonusTraverseLuggages definitions name
