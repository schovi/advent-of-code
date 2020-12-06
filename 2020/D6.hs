import Common

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readResponses $ readLines "inputs/6.test.input"
  print result

  print "Regular:"
  let result = solution $ readResponses $ readLines "inputs/6.input"
  print result

  print "Bonus Test:"
  print $ readResponses $ readLines "inputs/6.test.input"
  let result = bonusSolution $ readResponses $ readLines "inputs/6.test.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readResponses $ readLines "inputs/6.input"
  print result

readResponses :: [String] -> [[String]]
readResponses = split ""

solution :: [[String]] -> Int
solution groups = sum $ map (calculateGroup . concat) groups

calculateGroup :: String -> Int
calculateGroup (x:xs) = current + next
                    where current = if x `elem` xs then 0 else 1
                          next    = calculateGroup xs
calculateGroup [] = 0

-- bonus

bonusSolution :: [[String]] -> Int
bonusSolution groups = sum $ map bonusCalculateGroup groups

bonusCalculateGroup :: [String] -> Int
bonusCalculateGroup groupAnswers = length $ filter isInAllGroups allAnswers
  where allAnswers           = unique . concat $ groupAnswers
        isInAllGroups answer = all (elem answer) groupAnswers
