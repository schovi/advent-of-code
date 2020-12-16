
import Common
import Data.Set (Set)
import qualified Data.Set as Set

-- import Data.List (find)

-- import Data.Map (Map)
-- import qualified Data.Map as Map

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readInput "inputs/16.test.input"
  print result

  print "Regular:"
  let result = solution $ readInput "inputs/16.input"
  print result

  -- print "Bonus test:"
  -- let result = solution 30000000 $ readInput "inputs/15.test.input"
  -- print result

  -- print "Bonus:"
  -- let result = solution 30000000 $ readInput "inputs/15.input"
  -- print result

type Range   = Set Int
type Tickets = [Int]
type Input = (Range, Tickets)
readInput :: String -> Input
readInput file = let lines                = readLines file
                     (limits:my:nearby:_) = split "" lines
                     ranges               = concatMap (filter (/= "or") . words . last . split ':') limits
                     validTickets         = foldl folder Set.empty ranges
                     folder set range     = Set.union set $ rangeToList (split '-' range)
                     rangeToList (a:b:_)  = Set.fromList [(read a)..(read b)]
                     nearbyTickets        = map read $ concatMap (split ',') $ tail nearby
                 in (validTickets, nearbyTickets)

solution :: Input -> Int
solution (validTickets, nearby) = sum $ filter notValid nearby
  where notValid ticket = Set.notMember ticket validTickets
