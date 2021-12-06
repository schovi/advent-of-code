import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.Map (Map)

main :: IO ()
main = do
  let result = solution $ parseLines linesFilter $ readLines "inputs/5.test.input"
  print result
  let result = solution $ parseLines linesFilter $ readLines "inputs/5.input"
  print result
  let result = solution $ parseLines bonusLinesFilter $ readLines "inputs/5.test.input"
  print result
  let result = solution $ parseLines bonusLinesFilter $ readLines "inputs/5.input"
  print result

type Coord = (Int, Int)
type Vents = Map Coord Int
type LinesFilter = ((Coord, Coord) -> Bool)

-- Solution
solution vents = Map.size $ Map.filter (> 1) vents

linesFilter ((x1, y1), (x2, y2)) = x1 == x2 || y1 == y2

-- Bonus
bonusLinesFilter ((x1, y1), (x2, y2)) = x1 == x2 || y1 == y2 || x2 - x1 == y2 - y1  || x2 - x1 == y1 - y2

-- Parsers
parseLines :: LinesFilter -> [String] -> Vents
parseLines linesFilter lines = foldl counter Map.empty linesCoords
  where lineEdges = map parseLine lines
        linesCoords = concatMap generateLineCoords $ filter linesFilter lineEdges
        counter map coord = Map.alter updater coord map
        updater (Just count) = Just (count + 1)
        updater Nothing = Just 1

parseLine :: String -> (Coord, Coord)
parseLine line = (coord1, coord2)
  where (coord1:coord2:_) = map parseCoord $ case words line of (c1:_:c2:_) -> [c1, c2]
                                                                _ -> error "no no no"
        parseCoord coord = case splitToTuple ',' coord of (x, y) -> (read x, read y)

generateLineCoords :: (Coord, Coord) -> [Coord]
generateLineCoords coords@((x1, y1), (x2, y2))
  | x1 == x2 || y1 == y2 = [(x, y) | x <- [min x1 x2..max x1 x2], y <- [min y1 y2.. max y1 y2]]
  | x2 - x1 == y2 - y1 = zip [min x1 x2..max x1 x2] [min y1 y2..max y1 y2]
  | x2 - x1 == y1 - y2 = zip [min x1 x2..max x1 x2] $ reverse [min y1 y2..max y1 y2]
  | otherwise = []

-- orderCoords (a,b) = if a < b then (a, b) else (b, a)
