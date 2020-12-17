import Common
import Data.Maybe (isJust)

import Data.Set (Set)
import qualified Data.Set as Set

import Data.List (transpose)

main :: IO ()
main = do
  print "Bonus Test:"
  let result = solution 6 $ readSpace "inputs/17.test.input"
  print result

  print "Bonus Regular:"
  let result = solution 6 $ readSpace "inputs/17.input"
  print result

solution iterations space = length $ foldl (\s _ -> simulate s) space [1..iterations]

readSpace :: String -> Space
readSpace file = Set.fromList $ foldl rowsFolder [] $ zip [0..] (readLines file)
  where rowsFolder     coords (y, line) = foldl (columnFolder y) coords $ zip [0..] line
        columnFolder y coords (x, char) = charToCoord coords x y char
        charToCoord :: [Coord] -> Int -> Int -> Char -> [Coord]
        charToCoord coords x y '#' = [x, y, 0, 0] : coords
        charToCoord coords _ _ _ = coords

-- TODO: implement ord on data type
-- data Coord = Coord { x :: Int, y :: Int, z :: Int } deriving (Show, Ord)
type Coord = [Int] -- (Int, Int, Int)
type Space = Set Coord


simulate :: Space -> Space
simulate space = foldl (updateCoord space) space coords
  where axis                            = transpose $ Set.toList space
        (xLeft:yLeft:zLeft:wLeft:_)     = map (\a -> minimum a - 1) axis
        (xRight:yRight:zRight:wRight:_) = map (\a -> maximum a + 1) axis
        coords                          = [[x,y,z,w] | x <- [xLeft..xRight], y <- [yLeft..yRight], z <- [zLeft..zRight], w <- [wLeft..wRight] ]

updateCoord :: Space -> Space -> Coord -> Space
updateCoord currentSpace newSpace coord = if nextState currentSpace coord then Set.insert coord newSpace
                                                                          else Set.delete coord newSpace

nextState :: Space -> Coord -> Bool
nextState space coord@(x:y:z:w:_)
  | isActive && (activeNeigh == 2 || activeNeigh == 3) = True
  | not isActive && (activeNeigh == 3)                 = True
  | otherwise                                          = False
  where isActive           = Set.member coord space
        neighboursCoords   = [[x,y,z, w] | x <- [x-1..x+1], y <- [y-1..y+1], z <- [z-1..z+1], w <- [w-1..w+1], [x,y,z,w] /= coord]
        activeNeigh        = length $ filter (`Set.member` space) neighboursCoords
