import Common
import Debug.Trace
import Data.Char (digitToInt)

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.Set as Set
import Data.Set (Set)

import qualified Data.List as List

import Data.Maybe (mapMaybe)
import Control.Concurrent.STM (check)

main :: IO ()
main = do
  let result = solution 100 $ readOctopuses "inputs/11.test.input"
  print result
  let result = solution 100 $ readOctopuses "inputs/11.input"
  print result
  let result = bonusSolution $ readOctopuses "inputs/11.test.input"
  print result
  let result = bonusSolution $ readOctopuses "inputs/11.input"
  print result

side = 10

-- data Coord = Coord { x :: Int,
--                      y :: Int
--                    } deriving (Eq, Ord, Show)

type Coord = (Int, Int)
type EnergyLevel = Int
type Octopuses = Map Coord EnergyLevel

readOctopuses :: String -> Octopuses
readOctopuses path = foldl columnsFolder Map.empty $ zip [0..] (readLines path)
  where columnsFolder coords (x, line) = foldl (rowsFolder x) coords $ zip [0..] line
        rowsFolder x coords (y, char) = Map.insert (x, y) (digitToInt char) coords

printOctopuses :: Octopuses -> IO ()
printOctopuses octopuses = putStrLn $ List.intercalate "\n" $ map columns [0..side-1]
  where columns y = concatMap (show . rows y) [0..side-1]
        rows y x = octopuses Map.! (y, x)

-- solution :: Int -> Octopuses -> Int
solution steps octopuses = counter
  where (counter, octopuses') = foldl folder (0, octopuses) [1..steps]
        folder prevResult _ = simulateStep prevResult

simulateStep :: (Int, Octopuses) -> (Int, Octopuses)
simulateStep (counter, octopuses) =  (counter + counter', octopuses'')
  where octopuses' = Map.map (+1) octopuses
        (counter', octopuses'') = simulateFlashes octopuses'

simulateFlashes :: Octopuses -> (Int,Octopuses)
simulateFlashes = simulateFlashes' 0

simulateFlashes' :: Int -> Octopuses -> (Int, Octopuses)
simulateFlashes' counter octopuses
  | currentCounter == 0 = (counter, octopuses)
  | otherwise = simulateFlashes' (counter + currentCounter) $ Map.foldrWithKey flashOctopus octopuses octopusesToFlash
  where octopusesToFlash = Map.filter (>9) octopuses
        currentCounter = Map.size octopusesToFlash

flashOctopus :: Coord -> EnergyLevel -> Octopuses -> Octopuses
flashOctopus coord _ octopuses = Map.insert coord 0 octopuses''
  where octopuses'' = foldl folder octopuses neighbourCoords
        folder octopuses' coord' = Map.adjust (\level -> if level == 0 then 0 else level + 1) coord' octopuses'
        neighbourCoords = getNeighbourCoords coord octopuses

getNeighbourCoords :: Coord -> Octopuses -> [Coord]
getNeighbourCoords coord@(x, y) octopuses = coords
  where coords = [(x', y') | x' <- [x-1..x+1], y' <- [y-1..y+1], (x',y') /= coord && x' >= 0 && y' >= 0 && x' < side &&  y' < side]

-- Bonus

bonusSolution :: Octopuses -> (Int, Octopuses)
bonusSolution octopuses = (step, octopuses')
  where (step, octopuses') = bonusSimultaneousFlashes 1 octopuses

bonusSimultaneousFlashes :: Int -> Octopuses -> (Int, Octopuses)
bonusSimultaneousFlashes step octopuses
  | all (==0) $ Map.elems octopuses' = (step, octopuses')
  | otherwise = bonusSimultaneousFlashes (step + 1) octopuses'
  where (_, octopuses') = simulateStep (0, octopuses)
