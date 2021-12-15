import Common
import Debug.Trace
import Data.Char (digitToInt)

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.Set as Set
import Data.Set (Set)

main :: IO ()
main = do
  let result = solution $ readCavern "inputs/15.test.input"
  print result
  let result = solution $ readCavern "inputs/15.input"
  print result
  let result = solution $ duplicateCavern 5 $ readCavern "inputs/15.test.input"
  print result
  let result = solution $ duplicateCavern 5 $ readCavern "inputs/15.input"
  print result

type Coord = (Int, Int)
type RiskLevel = Int
type Cavern = Map Coord RiskLevel

readCavern :: String -> Cavern
readCavern path = foldl columnsFolder Map.empty $ zip [0..] (readLines path)
  where columnsFolder coords (x, line) = foldl (rowsFolder x) coords $ zip [0..] line
        rowsFolder x coords (y, char) = Map.insert (x, y) (digitToInt char) coords

solution cavern = result Map.! (maxX, maxY)
  where cavern' = Map.insert (0,0) 0 cavern
        result = traverseCave (cavern', maxX, maxY)
        maxX = getMaxX cavern
        maxY = getMaxY cavern

type Visited = Map Coord Int

traverseCave c = visited
  where (visited, _) = bfs c initialVisited initialToVisit
        initialToVisit = [start]
        start = (0, 0)
        initialVisited = Map.fromList [(start, 0)]

bfs :: (Cavern, Int, Int) -> Visited -> [Coord] -> (Visited, [Coord])
bfs cavernState visited [] = (visited, [])
bfs cavernState visited coords = bfs cavernState visited' (Set.toList coordsSet)
  where (visited', coordsSet) = foldl folder (visited, Set.empty) coords
        folder (visited', nextToVisit) coord = case visitCave' cavernState visited' coord of (visited'', nextToVisit') -> (visited'', Set.union nextToVisit nextToVisit')

visitCave' :: (Cavern, Int, Int) -> Visited -> Coord -> (Visited, Set Coord)
visitCave' c@(cavern, maxX, maxY) visited coord@(x,y)
  | isEnd = (visited, Set.empty)
  | null nextToVisit = (visited, Set.empty)
  | otherwise = (visited', Set.fromList $ map snd nextToVisit)
  where visited' = foldl visitedFolder visited nextToVisit
        visitedFolder v (candidateRisk, candidateCoord) = Map.insert candidateCoord (currentSumRisk + candidateRisk) v

        nextToVisit = filter canVisit candidates
        canVisit (candidateRisk, candidateCoord) = case Map.lookup candidateCoord visited of Nothing -> True
                                                                                             Just candidateSumRisk -> candidateSumRisk > currentSumRisk + candidateRisk

        candidates = [(cavern Map.! (x', y'), (x', y')) | (x', y') <- [(x-1,y), (x+1,y), (x, y-1), (x, y+1)] , x' >= 0 && y' >= 0 && x' <= maxX && y' <= maxY]
        currentRisk = cavern Map.! coord
        currentSumRisk = visited Map.! coord
        isEnd = x == maxX && y == maxY

getMaxX :: Cavern -> Int
getMaxX = maximum . map fst . Map.keys

getMaxY :: Cavern -> Int
getMaxY = maximum . map snd . Map.keys

duplicateCavern :: Int -> Cavern -> Cavern
duplicateCavern duplications cavern = Map.foldrWithKey coordFolder Map.empty cavern
    where coordFolder :: Coord -> RiskLevel -> Cavern -> Cavern
          coordFolder coord risk resultCavern = foldr (xFolder coord risk) resultCavern [0..(duplications-1)]
          xFolder :: Coord -> RiskLevel -> Int -> Cavern -> Cavern
          xFolder coord risk duplicationX resultCavern = foldr (yFolder coord risk duplicationX) resultCavern [0..(duplications-1)]
          yFolder :: Coord -> RiskLevel -> Int -> Int -> Cavern -> Cavern
          yFolder (x,y) risk duplicationX duplicationY resultCavern = Map.insert (x + (maxX * duplicationX), y + (maxY * duplicationY)) newRisk resultCavern
            where riskSum = risk + duplicationX + duplicationY
                  newRisk = if riskSum > 9 then (riskSum `mod` 10) + 1 else riskSum
          maxX = getMaxX cavern + 1
          maxY = getMaxY cavern + 1
