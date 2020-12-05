import Common
import Data.List (sort)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readBoardingPass $ readLines "inputs/5.test.input"
  print result

  print "Regular:"
  let result = solution $ readBoardingPass $ readLines "inputs/5.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readBoardingPass $ readLines "inputs/5.input"
  print result

type BoardingPass = (String, String)

readBoardingPass :: [String] -> [BoardingPass]
readBoardingPass = map (splitAt 7)

solution :: [BoardingPass] -> Int
solution = maximum . calculateBoardingPassesIds

bonusSolution :: [BoardingPass] -> Int
bonusSolution passes = findMissingBoardingPassId . sort $ calculateBoardingPassesIds passes

findMissingBoardingPassId :: [Int] -> Int
findMissingBoardingPassId (x:y:xs) = if x == y - 1 then findMissingBoardingPassId (y : xs) else y - 1
findMissingBoardingPassId (x:_)    = x

calculateBoardingPassesIds :: [BoardingPass] -> [Int]
calculateBoardingPassesIds = map calculateBoardingPassId

calculateBoardingPassId :: BoardingPass -> Int
calculateBoardingPassId (rowId, seatId) = calculateRow rowId * 8 + calculateSeat seatId

calculateRow :: String -> Int
calculateRow ('B':xs) = 2 ^ length xs + calculateRow xs
calculateRow ('F':xs) = 0 + calculateRow xs
calculateRow []       = 0

calculateSeat :: String -> Int
calculateSeat ('R':xs) = 2 ^ length xs + calculateSeat xs
calculateSeat ('L':xs) = 0 + calculateSeat xs
calculateSeat []       = 0
