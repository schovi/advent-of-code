import Common

main :: IO ()
main = do
  let result = solution $ readInt "inputs/1.test.input"
  print result
  let result = solution $ readInt "inputs/1.input"
  print result
  let result = solution $ bonusPrepareGroups $ readInt "inputs/1.test.input"
  print result
  let result = solution $ bonusPrepareGroups $ readInt "inputs/1.input"
  print result

type Definition = (Int, Int, Char, String)

solution :: [Int] -> Int
solution (x:y:xs) = if y > x then 1 + next else next
  where next = solution (y:xs)
solution _ = 0

bonusPrepareGroups :: [Int] -> [Int]
bonusPrepareGroups (x:y:z:xs) = x + y + z : bonusPrepareGroups (y:z:xs)
bonusPrepareGroups _ = []
