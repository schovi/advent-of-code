import Common

import Data.List (transpose)

import Data.Set (Set)
import qualified Data.Set as Set

main :: IO ()
main = do
  let result = solution $ readInput $ readLines "inputs/24.test.input"
  print result

  let result = solution $ readInput $ readLines "inputs/24.input"
  print result

  let result = bonusSolution $ readInput $ readLines "inputs/24.test.input"
  print result

  let result = bonusSolution $ readInput $ readLines "inputs/24.input"
  print result

data Coord = Coord { x :: Int, y :: Int } deriving (Show, Eq, Ord)

data Direction = E | SE | NE | W | SW | NW deriving (Show, Eq, Ord)

type Grid = Set Coord

readInput :: [String] -> [[Direction]]
readInput = map parseLine

parseLine :: String -> [Direction]
parseLine [] = []

parseLine ('s' : 'e' : rest) = SE : parseLine rest
parseLine ('s' : 'w' : rest) = SW : parseLine rest

parseLine ('n' : 'e' : rest) = NE : parseLine rest
parseLine ('n' : 'w' : rest) = NW : parseLine rest

parseLine ('e' : rest)       = E : parseLine rest
parseLine ('w' : rest)       = W : parseLine rest

-- solution :: [[Direction]] -> Int
solution tiles = Set.size $ initialGrid tiles

tilesFolder :: Grid -> [Direction] -> Grid
tilesFolder grid tile = let coord = foldl navigateTo (Coord 0 0) tile
                        in if Set.member coord grid then Set.delete coord grid
                                                    else Set.insert coord grid

initialGrid :: [[Direction]] -> Grid
initialGrid = foldl tilesFolder emptyGrid
  where emptyGrid = Set.empty :: Grid

navigateTo :: Coord -> Direction -> Coord
navigateTo (Coord x y) E  = Coord (x + 1) y
navigateTo (Coord x y) SE = Coord (x + 1) (y - 1)
navigateTo (Coord x y) NE = Coord x       (y + 1)
navigateTo (Coord x y) W  = Coord (x - 1) y
navigateTo (Coord x y) SW = Coord x       (y - 1)
navigateTo (Coord x y) NW = Coord (x - 1) (y + 1)

bonusSolution tiles = length $ iterate simulate (initialGrid tiles) !! 100

simulate :: Grid -> Grid
simulate grid = foldl (updateCoord grid) grid coords
  where axis              = transpose $ map (\(Coord x y) -> [x, y] ) $ Set.toList grid
        (xLeft:yLeft:_)   = map (\a -> minimum a - 1) axis
        (xRight:yRight:_) = map (\a -> maximum a + 1) axis
        coords            = [Coord x y | x <- [xLeft..xRight], y <- [yLeft..yRight]]

updateCoord :: Grid -> Grid -> Coord -> Grid
updateCoord currentGrid newGrid coord = if nextState currentGrid coord then Set.insert coord newGrid
                                                                       else Set.delete coord newGrid

nextState :: Grid -> Coord -> Bool
nextState space coord@(Coord x y)
  | isActive && (activeNeigh == 0 || activeNeigh > 2) = False
  | not isActive && (activeNeigh == 2)                = True
  | otherwise                                         = isActive
  where isActive         = Set.member coord space
        neighboursCoords = map (navigateTo coord) [E, SE, NE, W, SW, NW]
        activeNeigh      = length $ filter (`Set.member` space) neighboursCoords
