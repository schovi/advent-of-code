import Common

main :: IO ()
main = do
  let result = solution $ parseInput $ readLines "inputs/2.test.input"
  print result
  let result = solution $ parseInput $ readLines "inputs/2.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/2.test.input"
  print result
  let result = bonusSolution $ parseInput $ readLines "inputs/2.input"
  print result

type Direction = String
type Command = (Direction, Int)

data Coord = Coord { x :: Int,
                     z :: Int,
                     aim :: Int
                   } deriving (Eq, Ord, Show)

parseInput :: [String] -> [Command]
parseInput = map parseLine

parseLine :: String -> Command
parseLine line = (direction, read amount)
  where (direction:amount:_) = words line

solution :: [Command] -> Int
solution commands = x * z
  where (Coord x z _) = foldl step (Coord 0 0 0) commands

step :: Coord -> Command -> Coord
step (Coord x z _) ("forward", amount) = Coord (x + amount) z 0
step (Coord x z _) ("down", amount) = Coord x (z + amount) 0
step (Coord x z _) ("up", amount) = Coord x (z - amount) 0
step _ _ = error "no no no"

-- Bonus
bonusSolution :: [Command] -> Int
bonusSolution commands = x * z
  where (Coord x z _) = foldl bonusStep (Coord 0 0 0) commands

bonusStep :: Coord -> Command -> Coord
bonusStep (Coord x z aim) ("forward", amount) = Coord (x + amount) (z + (aim * amount)) aim
bonusStep (Coord x z aim) ("down", amount) = Coord x z (aim + amount)
bonusStep (Coord x z aim) ("up", amount) = Coord x z (aim - amount)
bonusStep _ _ = error "no no no"
