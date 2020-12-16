
import Common
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Set (Set)
import qualified Data.Set as Set
import Data.List (transpose, find, isPrefixOf)

main :: IO ()
main = do
  -- print "Bonus test:"
  -- let result = solution $ readInput "inputs/16.bonus.test.input"
  -- print result

  print "Bonus:"
  let result = solution "inputs/16.input"
  print result


type Ticket = [Int]
type NearbyTickets = [Ticket]
type YourTicket = Ticket
type Property = (Int, String, [Int])
type Properties = [Property]
type Input = (Properties, YourTicket, NearbyTickets)

readInput :: String -> Input
readInput file = let lines                  = readLines file
                     (rawProps:my:nearby:_) = split "" lines
                 in (parseProperties rawProps, parseTicket $ my !! 1, map parseTicket $ tail nearby)

parseProperties :: [String] -> Properties
parseProperties = imap parseProperty

parseProperty :: Int -> String -> Property
parseProperty i line = (i, name, ranges)
  where (name:rawRanges:_) = split ':' line
        ranges              = concatMap (rangeToList . split '-') $ filter (/= "or") $ words rawRanges
        rangeToList (a:b:_) = [read a..read b]

parseTicket :: String -> Ticket
parseTicket line = map read $ split ',' line


-- solution :: Input -> Int
solution file = product $ map getTicketValue desiredProperties
-- solution file = tickets
  where (properties, myTicket, _) = readInput file
        tickets = onlyValidTickets $ readNonBonusInput file
        columnsValues = imap (,) $ transpose tickets :: [(Int, [Int])]
        -- indexedTicket = Map.fromList $ imap (,) myTicket
        desiredProperties = filter (\(_,name,_) -> "departure" `isPrefixOf` name) properties
        mappedProperties = foldl (mapColumnsToProperty properties) Map.empty columnsValues
        -- mappedColumns = Map.fromList $ [(y,x) | (x,y) <- Map.toList mappedProperties]
        getTicketValue (i,_,_) = case Map.lookup i mappedProperties of Just columnIndex -> myTicket !! columnIndex
                                                                       Nothing          -> error "no no no no"

type MappedColumns = Map Int Int
-- Returns map propertyIndex -> columnIndex
mapColumnsToProperty :: Properties -> MappedColumns -> (Int, [Int]) -> MappedColumns
mapColumnsToProperty properties result (columnIndex, values) =
  case property of Just (propertyIndex, _, _) -> Map.insert propertyIndex columnIndex result
                   Nothing                    -> error "boom"
  where property                  = find matchProperty properties
        matchProperty (i,_,range) = Map.notMember i result && all (`elem` range) values


-- Copy & enhanced non bonus part


type Range   = Set Int
type Tickets = [[Int]]
type NonBonusInput = (Range, Tickets)
readNonBonusInput :: String -> NonBonusInput
readNonBonusInput file = let lines                = readLines file
                             (limits:my:nearby:_) = split "" lines
                             ranges               = concatMap (filter (/= "or") . words . last . split ':') limits
                             validTickets         = foldl folder Set.empty ranges
                             folder set range     = Set.union set $ rangeToList (split '-' range)
                             rangeToList (a:b:_)  = Set.fromList [(read a)..(read b)]
                             nearbyTickets        = map (map read . split ',') $ tail nearby
                          in (validTickets, nearbyTickets)

onlyValidTickets :: NonBonusInput -> [[Int]]
onlyValidTickets (validIds, tickets) = filter isValid tickets
  where isValid ticket = all (`Set.member` validIds) ticket
