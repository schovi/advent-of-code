import Common

main :: IO ()
main = do
  let result = solution $ readNumbers "inputs/1.test.input"
  print result
  let result = solution $ readNumbers "inputs/1.input"
  print result
  --let result = solution bonusIsDefinitionValid $ parseInput $ readLines "inputs/2.input"
  --print result

type Definition = (Int, Int, Char, String)

solution :: [Integer] -> Int
solution (x:y:xs) = if y > x then 1 + next
                             else next
  where next = solution (y:xs)

solution _ = 0
