import Common

main :: IO ()
main = do
  let result = solution $ readNumbers "inputs/1.input"
  print result
  let bonus = solutionBonus $ readNumbers "inputs/1.input"
  print bonus

solution ::  [Integer] -> Integer
solution numbers = a * b
  where (a, b) = head [ (a, b) | a <- numbers, b <- numbers,  a + b == 2020]

solutionBonus ::  [Integer] -> Integer
solutionBonus numbers = a * b * c
  where (a, b, c) = head [ (a, b, c) | a <- numbers, b <- numbers, c <- numbers,  a + b + c == 2020]
