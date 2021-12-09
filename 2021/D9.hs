import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)
import Data.Char (digitToInt)
import Data.List (sortBy)

main :: IO ()
main = do
  let result = solution $ readHeighMap "inputs/9.test.input"
  print result
  let result = solution $ readHeighMap "inputs/9.input"
  print result
  let result = bonusSolution $ readHeighMap "inputs/9.test.input"
  print result
  let result = bonusSolution $ readHeighMap "inputs/9.input"
  print result

data Coord = Coord { x :: Int,
                     y :: Int
                   } deriving (Eq, Ord, Show)

type HeighMap = Map Coord Int

readHeighMap :: String -> HeighMap
readHeighMap path = foldl rowsFolder Map.empty $ zip [0..] (readLines path)
  where rowsFolder coords (y, line) = foldl (columnFolder y) coords $ zip [0..] line
        columnFolder y coords (x, char) = Map.insert (Coord x y) (digitToInt char) coords

solution = sum . map (+1) . Map.elems . findLowPoints

findLowPoints heighMap = Map.filterWithKey (isLowPoint heighMap) heighMap

isLowPoint heighMap coord value = all (> value) neighbourValues
  where neighbourValues = getNeighbourValues coord heighMap

getNeighbourValues coord heighMap = map (\(Coord x' y') -> heighMap Map.! Coord x' y') coords
  where coords = getNeighbourCoords coord heighMap

getNeighbourCoords (Coord x y) heighMap = [Coord x' y' | (x', y') <- [(x-1, y), (x+1, y), (x, y-1), (x, y+1)], Map.member (Coord x' y') heighMap]

-- Bonus

bonusSolution = product . take 3 . sortBy (flip compare) . map Map.size . findBasins

findBasins heighMap = findBasin' (Map.filter (<9) heighMap)

findBasin' unexploredHeighMap
  | Map.null unexploredHeighMap = []
  | otherwise = basin : findBasin' unexploredHeighMap'
  where coord = head $ Map.keys unexploredHeighMap
        (basin, unexploredHeighMap')  = traverseMapBasin coord Map.empty unexploredHeighMap

traverseMapBasin :: Coord -> HeighMap -> HeighMap -> (HeighMap, HeighMap)
traverseMapBasin coord visited unexploredHeighMap
  | null neighbourCoords = (visited', unexploredHeighMap')
  | otherwise = foldl folder (visited', unexploredHeighMap') neighbourCoords
  where neighbourCoords = filter (\coord' -> not $ Map.member coord' visited') $ getNeighbourCoords coord unexploredHeighMap
        (visited', unexploredHeighMap') = moveCoord coord visited unexploredHeighMap
        folder (visited'', unexploredHeighMap'') coord'' = if Map.member coord'' unexploredHeighMap'' then traverseMapBasin coord'' visited'' unexploredHeighMap''
                                                                                                      else (visited'', unexploredHeighMap'')

moveCoord coord visited heighMap = (Map.insert coord (heighMap Map.! coord) visited, Map.delete coord heighMap)
