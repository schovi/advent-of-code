import Common
import Data.List (find)

main :: IO ()
main = do
  print "Test:"
  let result = 51 == solution ["1 + (2 * 3) + (4 * (5 + 6))"]
  print result

  print "Regular:"
  let result = solution $ readLines "inputs/18.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readLines "inputs/18.input"
  print result

solution :: [String] -> Int
solution lines = sum $ map (calculate . lexer) lines

-- bonusSolution :: [String] -> Int
bonusSolution lines = map (calculateBonus . lexer) lines

data Token
  = PlusTok
  | TimesTok
  | OpenTok
  | CloseTok
  | IntTok Int
  deriving (Show, Eq)

-- Parser
lexer :: String -> [Token]
lexer []              = []
lexer ('+' : restStr) = PlusTok  : lexer restStr
lexer ('*' : restStr) = TimesTok : lexer restStr
lexer ('(' : restStr) = OpenTok  : lexer restStr
lexer (')' : restStr) = CloseTok : lexer restStr
lexer (' ' : restStr) = lexer restStr
lexer str             = IntTok (read digitStr) : lexer restStr
                        where (digitStr, restStr) = span isDigit str

isDigit :: Char -> Bool
isDigit = (`elem` ['0'..'9'])


calculate :: [Token] -> Int
calculate = calculate' [] []

calculate' :: [Token] -> [Token] -> [Token] -> Int

-- End state
calculate' [IntTok value] ops [] = value

-- Calculate two numbers on a stack
calculate' (IntTok a : IntTok b : stack) (op : ops) tokens = calculate' (IntTok (calculateNumbers' op a b) : stack) ops tokens

-- A Number
calculate' stack ops (number@(IntTok _) : tokens) = calculate' (number : stack) ops tokens

-- Opening bracket
calculate' stack ops (OpenTok : tokens) = calculate' (OpenTok : stack) ops tokens

-- Operations
calculate' stack ops (TimesTok : tokens) = calculate' stack (TimesTok : ops) tokens
calculate' stack ops (PlusTok : tokens)  = calculate' stack (PlusTok : ops) tokens

-- Closing Bracket -> remove the opening bracket from the stack
calculate' (number@(IntTok _) : OpenTok : stack) ops (CloseTok : tokens) = calculate' (number : stack) ops tokens

calculateNumbers' op a b = case op of PlusTok -> a + b; TimesTok ->  a * b

calculateBonus :: [Token] -> Int
calculateBonus tokens = case result of Just ([IntTok value], _, _) -> value
                                       _                         -> error "boom"
  where iterations = iterate step' ([], [], tokens)
        result = find isResult iterations
        isResult ([IntTok value], _, []) = True
        isResult _ = False

step' :: ([Token], [Token], [Token]) -> ([Token], [Token], [Token])

-- End state -> Multiply rest
step' (IntTok a : IntTok b : stack, op : ops, []) = (IntTok (calculateNumbers' op a b) : stack, ops, [])

step' result@(_, _, []) = result

-- Calculate two numbers on a stack when going forward
step' (IntTok a : stack, PlusTok : ops, IntTok b : tokens) = (IntTok (a + b) : stack, ops, tokens)

-- A Number
step' (stack, ops, number@(IntTok _) : tokens) = (number : stack, ops, tokens)

-- Opening bracket
step' (stack, ops, OpenTok : tokens) = (OpenTok : stack, ops, tokens)

-- Operations
step' (stack, ops, TimesTok : tokens) = (stack, TimesTok : ops, tokens)
step' (stack, ops, PlusTok : tokens)  = (stack, PlusTok : ops, tokens)

-- Closing bracket -> going back and multiply numbers
step' (IntTok a : IntTok b : stack, op : ops, tokens@(CloseTok : _)) = (IntTok (calculateNumbers' op a b) : stack, ops, tokens)

-- Closing Bracket -> remove the opening bracket from the stack
step' (number@(IntTok _) : OpenTok : stack, ops, CloseTok : tokens) = (number : stack, ops, tokens)
