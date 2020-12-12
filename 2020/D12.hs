import Common
-- import Data.Maybe (isJust)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readInstructions $ readLines "inputs/12.test.input"
  print result

  print "Regular:"
  let result = solution $ readInstructions $ readLines "inputs/12.input"
  print result

  -- print "Bonus Test:"
  -- let result = solution bonusSimulate $ readLines "inputs/12.test.input"
  -- print result

  -- print "Bonus:"
  -- let result = solution bonusSimulate $ readLines "inputs/12.input"
  -- print result

type Instruction = (Char, Int)
type Position    = (Char, Int, Int)

readInstructions :: [String] -> [Instruction]
readInstructions = map parser
  where parser instruction = (head instruction, (read . tail) instruction)

solution :: [Instruction] -> Int
solution instructions = abs x + abs y
  where currentPosition = ('E', 0, 0)
        (_, x, y)    = travel currentPosition instructions

travel :: Position -> [Instruction] -> Position
travel position []                         = position
travel position (instruction:instructions) = travel nextPosition instructions
  where nextPosition = updatePosition position instruction

updatePosition :: Position -> Instruction -> Position
updatePosition (facing, x, y) ('N', arg) = (facing, x,       y + arg)
updatePosition (facing, x, y) ('S', arg) = (facing, x,       y - arg)
updatePosition (facing, x, y) ('E', arg) = (facing, x + arg, y)
updatePosition (facing, x, y) ('W', arg) = (facing, x - arg, y)
updatePosition (facing, x, y) ('L', arg) = (rotateLeft facing arg, x, y)
updatePosition (facing, x, y) ('R', arg) = (rotateLeft facing (360 - arg), x, y)
updatePosition position       ('F', arg) = moveForward position arg

rotateLeft :: Char -> Int -> Char
rotateLeft facing rotate = directions !! (rotate `div` 90)
  where directions = dropWhile (/= facing) $ cycle "NWSE"

moveForward :: Position -> Int -> Position
moveForward ('N', x, y) len = ('N', x,       y + len)
moveForward ('E', x, y) len = ('E', x + len, y)
moveForward ('S', x, y) len = ('S', x,       y - len)
moveForward ('W', x, y) len = ('W', x - len, y)
