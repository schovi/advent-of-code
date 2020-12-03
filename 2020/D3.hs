import Common

main :: IO ()
main = do
  let result = solution $ readLines "inputs/3.test.input"
  print result

  let result = solution $ readLines "inputs/3.input"
  print result

  let result = bonusSolution bonusSlopes $ readLines "inputs/3.test.input"
  print result

  let result = bonusSolution bonusSlopes $ readLines "inputs/3.input"
  print result

tree = '#'
bonusSlopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

solution ::  [String] -> Int
solution lines = processSlope lines (3, 1)

bonusSolution :: [(Int, Int)] -> [String] -> Int
bonusSolution slopes lines = foldr (*) 1 slopesResults
            where slopesResults = map (processSlope lines) slopes

processSlope :: [String] -> (Int, Int) -> Int
processSlope (_:lines) (right, down)  = length $ filter (== tree) encounters
        where correctLines = takeEvery lines down
              rightSteps   = [right, right + right .. ]
              encounters   = map processLine $ zip correctLines rightSteps

processLine :: (String, Int) -> Char
processLine (line, index) = inifinLine !! index
              where inifinLine = cycle line
