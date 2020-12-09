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

  -- print "Bonus Test:"
  -- let result = bonusSolution $ readLines "inputs/8.test.input"
  -- print result

  -- print "Bonus:"
  -- let result = bonusSolution $ readLines "inputs/8.input"
  -- print result

solution :: Int -> [Int] -> Int
solution preambleSize numbers = case find findNonCountable combinations of
                                  Just (value,_) -> value
                                  _          -> error "boom"
  where combinations              = sliceNumbers preambleSize numbers

sliceNumbers :: Int -> [Int] -> [(Int, [Int])]
sliceNumbers preambleSize numbers@(_:next)
  | preambleSize > length numbers   = []
  | otherwise                       = (theNumber, preamble) : sliceNumbers preambleSize next
  where preamble  = take preambleSize numbers
        theNumber = numbers !! preambleSize

findNonCountable :: (Int, [Int]) -> Bool
findNonCountable (theNumber, numbers) = null combinations
  where combinations = [ (x,y) | x <- numbers, y <- numbers, x + y == theNumber ]
