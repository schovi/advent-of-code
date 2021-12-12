{-# LANGUAGE TupleSections #-}

import Common
import Debug.Trace

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.List as List

import Data.Maybe (mapMaybe, fromMaybe, fromJust)

main :: IO ()
main = do
  -- let result = solution getNextState $ readMap "inputs/12.test.input"
  -- print result
  -- let result = solution getNextState $ readMap "inputs/12.test2.input"
  -- print result
  -- let result = solution getNextState $ readMap "inputs/12.test3.input"
  -- print result
  -- let result = solution getNextState $ readMap "inputs/12.input"
  -- print result
  -- print "bonus"
  let result = solution bonusGetNextState $ readMap "inputs/12.test.input"
  print result
  let result = solution bonusGetNextState $ readMap "inputs/12.test2.input"
  print result
  let result = solution bonusGetNextState $ readMap "inputs/12.test3.input"
  print result
  let result = solution bonusGetNextState $ readMap "inputs/12.input"
  print result

type Cave = String
type Nodes = [Cave]
type CavesMap = Map Cave Nodes
type Path = (Cave, Cave)
type Paths = [Path]
type Route = [Paths]
type GetNodes = Cave -> Nodes

type Visits = Map Cave Bool
type State = (CavesMap, Visits)

solution getNextState cavesMap = case result of Just paths -> length paths
                                                Nothing -> error "no no no "
  where result = traverseCaves getNextState (cavesMap, Map.empty) "start" []

printPaths paths = putStrLn . List.intercalate "\n" $ map prepare paths
  where prepare path = List.intercalate "," (reverse path)

getNextState :: State -> Cave -> Maybe State
getNextState state@(cavesMap, visits) cave
  | not isSmall = Just state  -- we dont need to increase counter as the big caves can be visited many times
  | isSmall && not alreadyVisited = Just (cavesMap, Map.insert cave True visits)
  | otherwise = Nothing
  where isSmall = isSmallCave cave
        alreadyVisited = Map.member cave visits

traverseCaves :: (State -> Cave -> Maybe State) -> State -> Cave -> [Cave] -> Maybe [[Cave]]
traverseCaves getNextState state cave route
  | cave == "end" = Just [cave:route]
  | otherwise = traverseCaves' nextState getNextState cave route
  where nextState = getNextState state cave

traverseCaves' :: Maybe State -> (State -> Cave -> Maybe State) -> Cave -> [Cave] -> Maybe [[Cave]]
traverseCaves' Nothing _ _ _  = Nothing
traverseCaves' (Just nextState@(cavesMap, visits)) getNextState cave route = Just nextRoutes
  where nextRoutes = concat $ mapMaybe mapNextRoute nextNodes
        mapNextRoute toCave = traverseCaves getNextState nextState toCave currentRoute
        nextNodes = fromJust (Map.lookup cave cavesMap)
        currentRoute = cave : route

-- Bonus

alreadyVisitedSmallKey = "__alreadyVisitedSmall__"

bonusGetNextState :: State -> Cave -> Maybe State
bonusGetNextState state@(cavesMap, visits) cave
  | not isSmall = Just state  -- we dont need to increase counter as the big caves can be visited many times
  | notVisited = Just (cavesMap, withCurrentVisit)
  | not (isStart || isEnd) && notYetVisitedAgain = Just (cavesMap, Map.insert alreadyVisitedSmallKey True withCurrentVisit)
  | otherwise = Nothing
  where isStart = cave == "start"
        isEnd = cave == "end"
        isSmall = isSmallCave cave
        notVisited = Map.notMember cave visits
        notYetVisitedAgain = Map.notMember alreadyVisitedSmallKey visits
        withCurrentVisit = Map.insert cave True visits

-- parsing
readMap :: String -> CavesMap
readMap = foldl folder Map.empty . map (splitToTuple '-') . readLines
  where folder map (from, to) = Map.alter (alterer from) to $ Map.alter (alterer to) from map
        alterer cave Nothing = Just [cave]
        alterer cave (Just caves) = Just (cave : caves)

-- helpers
getNodes :: CavesMap -> Cave -> Maybe Nodes
getNodes cavesMap cave = Map.lookup cave cavesMap

smallLetters = ['a'..'z']

isSmallCave :: String -> Bool
isSmallCave = all (`elem` smallLetters)
