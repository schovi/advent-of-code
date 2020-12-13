import Common
import Data.List (find)
import Control.Monad (zipWithM)

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readInput $ readLines "inputs/13.test.input"
  print result

  print "Regular:"
  let result = solution $ readInput $ readLines "inputs/13.input"
  print result

  print "Bonus Test:"
  let result = bonusSolution $ readBonusInput $ readLines "inputs/13.test.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readBonusInput $ readLines "inputs/13.input"
  print result

type Input = (Int, [Int])
readInput :: [String] -> Input
readInput (timestamp:timetable:_) = (read timestamp, map read busses)
  where splitted = split ',' timetable
        busses   = filter (/= "x") splitted

solution :: Input -> Int
solution (timestamp, busses) = let (departIn, busNumber) = minimum $ map (closestBusDepart timestamp) busses
                               in departIn * busNumber

closestBusDepart :: Int -> Int -> (Int, Int)
closestBusDepart timestamp interval = (interval - timestamp `mod` interval, interval)

-- Bonus

type BonusInput = [(Int, Int)]

readBonusInput :: [String] -> BonusInput
readBonusInput (_:timetable:_) = busses
  where splitted          = split ',' timetable

        withIndex         = zipWith indexMapper [0..] splitted
        indexMapper i val = (-i, val)

        filtered            = filter filterOutX withIndex
        filterOutX (_, val) = val /= "x"

        busses              = map parser filtered
        parser (i, val)     = (i, read val)

bonusSolution busses = chineseRemainder indices departures
  where indices    = map fst busses
        departures = map snd busses

-- Taken from https://rosettacode.org/wiki/Chinese_remainder_theorem#Haskell

egcd :: Int -> Int -> (Int, Int)
egcd _ 0 = (1, 0)
egcd a b = (t, s - q * t)
  where
    (s, t) = egcd b r
    (q, r) = a `quotRem` b

modInv :: Int -> Int -> Either String Int
modInv a b =
  case egcd a b of
    (x, y)
      | a * x + b * y == 1 -> Right x
      | otherwise ->
        Left $ "No modular inverse for " ++ show a ++ " and " ++ show b

chineseRemainder :: [Int] -> [Int] -> Either String Int
chineseRemainder residues modulii =
  zipWithM modInv crtModulii modulii >>=
  (Right . (`mod` modPI) . sum . zipWith (*) crtModulii . zipWith (*) residues)
  where
    modPI = product modulii
    crtModulii = (modPI `div`) <$> modulii
