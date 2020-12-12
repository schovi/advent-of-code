import Common
-- import Data.Maybe (isJust)

main :: IO ()
main = do
  print "Bonus Test:"
  let result = solution $ readInstructions $ readLines "inputs/12.test.input"
  print result

  print "Bonus:"
  let result = solution $ readInstructions $ readLines "inputs/12.input"
  print result

type Instruction = (Char, Int)
type Position    = (Char, Int, Int)
type Waypoint    = (Int, Int)

readInstructions :: [String] -> [Instruction]
readInstructions = map parser
  where parser instruction = (head instruction, (read . tail) instruction)

solution :: [Instruction] -> Int
solution instructions = abs x + abs y
  where position  = ('E', 0, 0)
        waypoint  = (10, 1)
        (_, x, y) = travel position waypoint instructions

travel :: Position -> Waypoint -> [Instruction] -> Position
travel position _ []                               = position

travel position waypoint (('F', len):instructions) = travel nextPosition waypoint instructions
  where nextPosition = updatePosition position waypoint len

travel position waypoint (instruction:instructions) = travel position nextWaypoint instructions
  where nextWaypoint = updateWaypoint waypoint instruction

updatePosition :: Position -> Waypoint -> Int -> Position
updatePosition (facing, x, y) (wX, wY) len = (facing, x + wX * len, y + wY * len)

updateWaypoint :: Waypoint -> Instruction -> Waypoint
updateWaypoint (wX, wY) ('N', arg) = (wX,       wY + arg)
updateWaypoint (wX, wY) ('E', arg) = (wX + arg, wY)
updateWaypoint (wX, wY) ('S', arg) = (wX,       wY - arg)
updateWaypoint (wX, wY) ('W', arg) = (wX - arg, wY)
updateWaypoint waypoint ('L', arg) = rotateLeft waypoint arg
updateWaypoint waypoint ('R', arg) = rotateLeft waypoint (360 - arg)

rotateLeft :: Waypoint -> Int -> Waypoint
rotateLeft (x, y) 90  = (-y,  x)
rotateLeft (x, y) 180 = (-x, -y)
rotateLeft (x, y) 270 = ( y, -x)
