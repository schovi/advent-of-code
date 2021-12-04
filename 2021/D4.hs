import Common
import Debug.Trace
import qualified Data.Map as Map
import Data.List (find)

main :: IO ()
main = do
  let result = solution play $ parseBingo $ readLines "inputs/4.test.input"
  print result
  let result = solution play $ parseBingo $ readLines "inputs/4.input"
  print result
  let result = solution bonusPlay $ parseBingo $ readLines "inputs/4.test.input"
  print result
  let result = solution bonusPlay $ parseBingo $ readLines "inputs/4.input"
  print result

data Coord = Coord { x :: Int, y :: Int } deriving (Show, Eq, Ord)
data Field = Field { value :: Int, marked :: Bool } deriving (Show, Eq)

type Board = Map.Map Coord Field

boardSize = 5

possibleLines = map (\x -> [Coord x y | y <- [0..boardSize-1]]) [0..boardSize-1] ++ map (\y -> [Coord x y | x <- [0..boardSize-1]]) [0..boardSize-1]

-- Solution
solution strategy (numbers, boards) = result
  where (winningNumber, board) = strategy numbers boards
        result = winningNumber * sum (map value $ filter (not.marked) $ Map.elems board)

play :: [Int] -> [Board] -> (Int, Board)
play [] boards = error "No no no"
play (number:numbers) boards = case winner of Just board -> (number, board)
                                              Nothing -> play numbers markedBoards
  where markedBoards = drawCard number boards
        winner       = find isWinner markedBoards

-- Bonus
bonusPlay :: [Int] -> [Board] -> (Int, Board)
bonusPlay [] boards = error "No no no"
bonusPlay (number:numbers) boards
  | length boards == 1 = case winner of Just board -> (number, board)
                                        Nothing    -> bonusPlay numbers markedBoards
  | otherwise = bonusPlay numbers nonWinningBoards
  where markedBoards     = drawCard number boards
        nonWinningBoards = filter (not.isWinner) markedBoards
        winner           = find isWinner markedBoards

-- Helpers
drawCard :: Int -> [Board] -> [Board]
drawCard number = map (markNumber number)

markNumber :: Int -> Board -> Board
markNumber number = Map.map (\(Field value marked) -> Field value (marked || value == number))

isWinner :: Board -> Bool
isWinner board = any isWinningLine possibleLines
  where isWinningLine line = all (\coord -> marked (board Map.! coord) ) line


-- Parsing
parseBingo :: [String] -> ([Int], [Board])
parseBingo [] = error "no no no"
parseBingo [_] = error "no no no"
parseBingo (numbers:_:rest) = (map read $ split ',' numbers, boards)
  where rawBoards = split "" rest
        boards = map parseBoard rawBoards

parseBoard :: [String] -> Board
parseBoard rows = Map.fromList $ concatMap parseRow $ zip [0..] rows

parseRow :: (Int, String) -> [(Coord, Field)]
parseRow (x, row) = map (\(y, val) -> (Coord x y, Field (read val) False)) columns
  where columns = zip [0..] $ filter (/= "") $ split ' ' row
