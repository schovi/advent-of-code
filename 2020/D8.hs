import Common

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readProgram $ readLines "inputs/8.test.input"
  print result

  print "Regular:"
  let result = solution $ readProgram $ readLines "inputs/8.input"
  print result

  -- print "Bonus Test:"
  -- let result = solution $ readProgram $ readLines "inputs/8.test.input"
  -- print result

  -- print "Bonus:"
  -- let result = solution $ readProgram $ readLines "inputs/8.input"
  -- print result

type Opcode      = String
type Argument    = Int
type Operator    = Char
type Instruction = (Opcode, Operator, Argument)

readProgram :: [String] -> [Instruction]
readProgram = map readLine

readLine :: String -> Instruction
readLine line = (opcode, head arg, read $ tail arg)
  where (opcode:arg:_) = words line

type Stack         = [Int]
type Accumulator   = Int
type Process       = ([Instruction], Stack, Accumulator)

data ProgramResult a = Loop a | End a

solution :: [Instruction] -> Int
solution instructions = case runProgram initialProgram of
                          Loop value -> value
                          _          -> error "Unexpected result of program"
                        where initialProgram = (instructions, [0], 0)

runProgram :: Process -> ProgramResult Int
runProgram (instructions, stack@(pointer:processed), acc)
  | infiniteLoop = Loop acc
  | finished     = End acc
  | otherwise    = runProgram (instructions, pointer + jumbBy : stack, acc + changeAcc)
  where infiniteLoop        = pointer `elem` processed
        finished            = pointer >= length instructions
        instruction         = instructions !! pointer
        (jumbBy, changeAcc) = evalInstruction instruction

evalInstruction :: Instruction -> (Int, Int)
evalInstruction ("nop", _, _)         = (1, 0)
evalInstruction ("jmp", operator, jumpBy)    = (if operator == '+' then jumpBy else (-jumpBy), 0)
evalInstruction ("acc", operator, changeAcc) = (1, if operator == '+' then changeAcc else (-changeAcc))

-- -- Bonus

-- solution :: [Instruction] -> Int
-- solution instructions =

-- generateVariations instructions =
