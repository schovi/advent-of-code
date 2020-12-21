import Common
import Data.List (sortOn, intersperse)

import Data.Map (Map)
import qualified Data.Map as Map

import Data.Set (Set)
import qualified Data.Set as Set

import Data.Maybe

import Debug.Trace

main :: IO ()
main = do
  let result = solution $ readRecipes "inputs/21.test.input"
  print result

  let result = solution $ readRecipes "inputs/21.input"
  print result

  let result = bonusSolution $ readRecipes "inputs/21.test.input"
  print result

  let result = bonusSolution $ readRecipes "inputs/21.input"
  print result

data Recipe = Recipe { ingredients :: [String],
                       allergens   :: [String]
                     } deriving (Show, Ord, Eq)

readRecipes file = map parseLine $ readLines file
  where parseLine line = let (ingredients, rawAllergens) = splitToTuple "(contains" $ words line
                         in Recipe ingredients (map (reject (`elem` [',', ')'])) rawAllergens)

type AllergenCandidate = Set String
type Candidates = Map String AllergenCandidate

solution recipes = length safeIngredients
  where candidates = foldl extractCandidates Map.empty recipes
        allergens  = reduceCandidates candidates
        safeIngredients = filterSafeIngredients recipes allergens

extractCandidates candidates recipe = foldl (extractAllergenCandidates (ingredients recipe)) candidates (allergens recipe)

extractAllergenCandidates ingredients candidates allergen = Map.insert allergen allergenCandidates candidates
  where previousCandidates = candidates Map.! allergen
        currentCandidates  = Set.fromList ingredients
        candidateExists    = Map.member allergen candidates
        allergenCandidates = if candidateExists then Set.intersection previousCandidates currentCandidates
                                                else Set.fromList ingredients

reduceCandidates candidates = Set.toList $ foldl1 Set.union (Map.elems candidates)

filterSafeIngredients recipes allergens = foldl folder [] recipes
  where folder allIngredient Recipe {ingredients = ingredients'} = reject (`elem` allergens) ingredients' ++ allIngredient

-- bonus

bonusSolution recipes = concat $ intersperse "," $ map snd $ sortOn fst allergens
  where candidates = foldl extractCandidates Map.empty recipes
        allergens  = matchAllergens candidates

type Allergens = Map String String

matchAllergens candidates = matchAllergens' [] listCandidates
  where listCandidates = map (\(x,y) -> (x, Set.toList y)) $ Map.toList candidates

matchAllergens' allergens [] = allergens
matchAllergens' allergens candidates = matchAllergens' ((allergen, ingredient) : allergens) (map cleanup rest)
  where ((allergen, [ingredient]):rest)  = sortOn (length . snd) candidates
        cleanup (allergen', ingredients) = (allergen', reject (== ingredient) ingredients)
