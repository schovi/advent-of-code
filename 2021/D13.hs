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
  let result = solution $ readPaper "inputs/13.test.input"
  print result
  let result = solution $ readPaper "inputs/13.input"
  print result
  let result = bonusSolution $ readPaper "inputs/13.test.input"
  print result
  -- printDots result
  -- print ""
  let result = bonusSolution $ readPaper "inputs/13.input"
  print result
  -- printDots result

side = 10

type Coord = (Int, Int)

type Dots = Map Coord Bool
type Fold = (Char, Int)
type Folds = [Fold]
type Paper = (Dots, Folds)

readPaper :: String -> Paper
readPaper path = (readDots dotsLines, readFolds foldsLines)
  where (dotsLines, foldsLines) = splitToTuple "" (readLines path)

readFolds :: [String] -> Folds
readFolds = map (parser . splitToTuple '=' . (!! 2) . words)
  where parser (dir, val) = (head dir, read val :: Int)

readDots = Map.fromList . map (parse . splitToTuple ',')
  where parse (x,y) = ((read x :: Int, read y :: Int), True)

printDots :: Dots -> IO ()
printDots dots = putStrLn $ List.intercalate "\n" $ map columns [0..getMaxY dots]
  where columns y = concatMap (rows y) [0..getMaxX dots]
        rows y x = if Map.member (x, y) dots then "#" else " "

-- Solution

solution (dots, fold:_) = Map.size $ applyFold fold dots


-- Bonus

bonusSolution (dots, folds) = foldl folder dots folds
  where folder dots fold = applyFold fold dots

-- Helpers

applyFold :: Fold -> Dots -> Dots
applyFold ('x', fold) dots = foldl (updateXCoord fold) dots coords
  where maxY = getMaxY dots
        coords = [(x, y) | x <- [fold+1..fold*2], y <- [0..maxY], Map.member (x, y) dots]

applyFold ('y', fold) dots = foldl (updateYCoord fold) dots coords
  where maxX = getMaxX dots
        coords = [(x, y) | x <- [0..maxX], y <- [fold+1..fold*2], Map.member (x, y) dots]

applyFold _ _ = error "no no no"

updateXCoord fold dots coord@(x,y) = if Map.member newCoord dots then dots' else Map.insert newCoord True dots'
  where newCoord = (fold*2 - x, y)
        dots' = Map.delete coord dots

updateYCoord fold dots coord@(x,y) = if Map.member newCoord dots then dots' else Map.insert newCoord True dots'
  where newCoord = (x, fold*2 - y)
        dots' = Map.delete coord dots

getMaxX :: Dots -> Int
getMaxX = maximum . map fst . Map.keys

getMaxY :: Dots -> Int
getMaxY = maximum . map snd . Map.keys
