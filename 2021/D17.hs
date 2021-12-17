{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Common
import Debug.Trace
import Data.Char (digitToInt)

import Data.Maybe (mapMaybe)

main :: IO ()
main = do
  -- let result = solution $ Target 20 30 (-10) (-5) -- "target area: x=20..30, y=-10..-5"
  -- print result
  -- let result = solution $ Target 206 260 (-105) (-57) -- "target area: x=206..250, y=-105..-57"
  -- print result

  -- let result = bonusSolution $ Target 20 30 (-10) (-5) -- "target area: x=20..30, y=-10..-5"
  -- print result
  let result = bonusSolution $ Target 206 250 (-105) (-57) -- "target area: x=206..250, y=-105..-57"
  print result

data Target = Target { minX :: Int, maxX :: Int, minY :: Int, maxY :: Int } deriving (Show)
data Velocity = Velocity { vx :: Int, vy :: Int } deriving Show
data Coord = Coord { x :: Int, y :: Int } deriving (Show, Eq)
data RelativePosition = Before | After | Hit deriving (Show, Eq)

initialCoord = Coord 0 0

solution target = maximum $ map (maximum.map y) trajectories
  where trajectories = generateTrajectories target

bonusSolution = length.generateTrajectories

initialVelocities = [Velocity x y | x <- [1..250], y <- [-105..5000]]

generateTrajectories :: Target -> [[Coord]]
generateTrajectories target  = mapMaybe (generateTrajectory target ) initialVelocities

generateTrajectory :: Target -> Velocity -> Maybe [Coord]
generateTrajectory target velocity = generateTrajectory' target velocity initialCoord

generateTrajectory' :: Target -> Velocity -> Coord -> Maybe [Coord]
generateTrajectory' target velocity coord
  | relativePosition == After = Nothing
  | relativePosition == Hit = Just [coord]
  | relativePosition == Before = case nextCoords of Just coords -> Just (coord : coords)
                                                    Nothing -> Nothing
  where nextCoords = generateTrajectory' target nextVelocity nextCoord
        nextCoord = Coord (x coord + vx velocity) (y coord + vy velocity)
        nextVelocity = Velocity (max (vx velocity - 1) 0) (vy velocity - 1)
        relativePosition = relativeToTarget target coord

relativeToTarget :: Target -> Coord -> RelativePosition
relativeToTarget (Target minX maxX minY maxY) (Coord x y)
  | x > maxX || y < minY = After
  | x >= minX && x <= maxX && y >= minY && y <= maxY = Hit
  | otherwise = Before
