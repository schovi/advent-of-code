import Common
import Data.List (find)

main :: IO ()
main = do
  print "Test:"
  let result = solution 5 $ map fromInteger $ readNumbers "inputs/9.test.input"
  print result

  print "Regular:"
  let result = solution 25 $ map fromInteger $ readNumbers "inputs/9.input"
  print result

  print "Bonus Test:"
  let result = bonusSolution 5 $ map fromInteger $ readNumbers "inputs/9.test.input"
  print result

  print "Bonus:"
  let result = bonusSolution 25 $ map fromInteger $ readNumbers "inputs/9.input"
  print result

solution :: Int -> [Int] -> Int
solution = findContiguousNumber

findContiguousNumber :: Int -> [Int] -> Int
findContiguousNumber preambleSize numbers =
  let combinations = sliceNumbers preambleSize numbers
      found        = find findNonCountable combinations
  in case found  of Just (value,_) -> value; _ -> error "boom"

sliceNumbers :: Int -> [Int] -> [(Int, [Int])]
sliceNumbers preambleSize numbers@(_:next)
  | preambleSize > length numbers   = []
  | otherwise                       = (theNumber, preamble) : sliceNumbers preambleSize next
  where preamble  = take preambleSize numbers
        theNumber = numbers !! preambleSize

findNonCountable :: (Int, [Int]) -> Bool
findNonCountable (theNumber, numbers) = null combinations
  where combinations = [ (x,y) | x <- numbers, y <- numbers, x + y == theNumber ]

-- bonus

bonusSolution :: Int -> [Int] -> Int
bonusSolution preambleSize numbers =
  let contiguousNumber = findContiguousNumber preambleSize numbers
      sequences        = followingSequences numbers
      found            = find finder sequences
      finder sequence  = sum sequence == contiguousNumber
  in case found of Just sequence -> minimum sequence + maximum sequence; _ -> error "boom"

followingSequences :: [a] -> [[a]]
followingSequences numbers@(frst:scnd:rest) = currentSequences ++ followingSequences (tail numbers)
  where beginning        = [[frst, scnd]]
        currentSequences = foldl folder beginning rest
        folder seq item  = seq ++ [last seq ++ [item]]
followingSequences _ = []
