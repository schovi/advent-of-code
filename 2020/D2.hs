import Common

main :: IO ()
main = do
  let result = solution isDefinitionValid $ parseInput $ readLines "inputs/2.input"
  print result
  let result = solution bonusIsDefinitionValid $ parseInput $ readLines "inputs/2.input"
  print result

type Definition = (Int, Int, Char, String)

parseInput :: [String] -> [Definition]
parseInput = map parsePasswordDefinition

parsePasswordDefinition :: String -> Definition
parsePasswordDefinition definition = (min, max, char, password)
  where tokens   = words definition
        range    = split '-' $ head tokens
        min      = read $ head range
        max      = read $ last range
        char     = head $ tokens !! 1
        password = tokens !! 2


solution ::  (Definition -> Bool) -> [Definition] -> Int
solution validator definitions = length $ filter validator definitions

isDefinitionValid ::  Definition -> Bool
isDefinitionValid (min, max, char, password) = min <= count && count <= max
                                 where count = length $ filter (== char) password

bonusIsDefinitionValid ::  Definition -> Bool
bonusIsDefinitionValid (index1, index2, char, password) =
                                 let characters   = map ((password !!) . subtract 1) [index1, index2]
                                     charCount    = length $ filter (== char) characters
                                  in charCount == 1
