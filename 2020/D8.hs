import Common
import Data.List (find)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readProgram $ readLines "inputs/8.test.input"
  print result

  print "Regular:"
  let result = solution $ readProgram $ readLines "inputs/8.input"
  print result

  print "Bonus Test:"
  let result = bonusSolution $ readProgram $ readLines "inputs/8.test.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readProgram $ readLines "inputs/8.input"
  print result

type Opcode      = String
type Argument    = Int
type Operator    = Char
type Instruction = (Opcode, Operator, Argument)
type Program     = [Instruction]

readProgram :: [String] -> Program
readProgram = map readLine

readLine :: String -> Instruction
readLine line = (opcode, head arg, read $ tail arg)
  where (opcode:arg:_) = words line

type Stack         = [Int]
type Accumulator   = Int
type Process       = (Program, Stack, Accumulator)

data ProgramResult a = Loop a | End a

solution :: Program -> Int
solution instructions = case (runProgram . initProcess) instructions of
                          Loop value -> value
                          _          -> error "Unexpected result of program"

initProcess :: Program -> Process
initProcess instructions = (instructions, [0], 0)

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

-- Bonus

bonusSolution :: Program -> Int
bonusSolution instructions = case result of
                               Just value -> case value of
                                               End value -> value
                                               _ -> error "Infinite loop error"
                               _          -> error "Program did not finished"
  where variations        = generateVariations instructions
        results           = map (runProgram . initProcess) variations
        result            = find isFinished results
        isFinished result = case result of End _ -> True; _ -> False

-- NOTE: I think it get correct solution by accident as I dont try all variations 😅
generateVariations :: Program -> [Program]
generateVariations program = program : generateNextVariant [] program

generateNextVariant :: [Instruction] -> [Instruction] -> [Program]
generateNextVariant prev (instruction:next) = currentVariants ++ nextVariants
  where instructionVariations = generateInstructionVariations instruction
        currentVariants       = map (\variation -> prev ++ [variation] ++ next) instructionVariations
        nextVariants          = generateNextVariant (prev ++ [instruction]) next

generateInstructionVariations :: Instruction -> [Instruction]
generateInstructionVariations instruction@("acc", _, _) = [instruction]
generateInstructionVariations (_, op, arg)              = [("jmp", op, arg), ("nop", op, arg)]
