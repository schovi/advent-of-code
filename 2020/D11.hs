import Common
import Data.Maybe (isJust)
main :: IO ()
main = do
  print "Test:"
  let result = solution simulate $ readLines "inputs/11.test.input"
  print result

  print "Regular:"
  let result = solution simulate $ readLines "inputs/11.input"
  print result

  print "Bonus Test:"
  let result = solution bonusSimulate $ readLines "inputs/11.test.input"
  print result

  print "Bonus:"
  let result = solution bonusSimulate $ readLines "inputs/11.input"
  print result

type Seats = [String]

solution :: (Seats -> Seats) -> Seats -> Int
solution simulation seats = length $ filter (== '#') $ unwords $ simulation seats

simulate :: Seats -> Seats
simulate seats
  | seats == next = next
  | otherwise     = simulate next
  where next = simulateStep seats

simulateStep :: Seats -> Seats
simulateStep seats = imap rowMapper seats
  where rowMapper y          = imap (columnMapper y)
        columnMapper _ _ '.' = '.'
        columnMapper y x 'L' = if adjacentOccupancy y x seats == 0 then '#' else 'L'
        columnMapper y x '#' = if adjacentOccupancy y x seats >= 4 then 'L' else '#'

adjacentOccupancy :: Int -> Int -> Seats -> Int
adjacentOccupancy y x seats = let left  = x - 1
                                  right = x + 1
                                  upper = y - 1
                                  lower = y + 1
                                  lookuper = lookupSeats seats
                                  tl = lookuper upper left
                                  tm = lookuper upper x
                                  tr = lookuper upper right
                                  ml = lookuper y     left
                                  mr = lookuper y     right
                                  bl = lookuper lower left
                                  bm = lookuper lower x
                                  br = lookuper lower right
                                  occupiedSeat (Just seat) = seat == '#'
                                  occupiedSeat _ = False
                              in length $ filter occupiedSeat [tl, tm, tr, ml, mr, bl, bm, br]


lookupSeats :: Seats -> Int -> Int -> Maybe Char
lookupSeats seats y x = let row  = getByindex y seats
                            seat = case row of Just row -> getByindex x row
                                               _        -> Nothing
                        in seat

-- bonus

bonusSimulate :: Seats -> Seats
bonusSimulate seats
  | seats == next = next
  | otherwise     = bonusSimulate next
  where next = bonusSimulateStep seats

bonusSimulateStep :: Seats -> Seats
bonusSimulateStep seats = imap rowMapper seats
  where rowMapper y          = imap (columnMapper y)
        columnMapper _ _ '.' = '.'
        columnMapper y x 'L' = if bonusAdjacentOccupancy y x seats == 0 then '#' else 'L'
        columnMapper y x '#' = if bonusAdjacentOccupancy y x seats >= 5 then 'L' else '#'

bonusAdjacentOccupancy :: Int -> Int -> Seats -> Int
bonusAdjacentOccupancy y x seats = let  lookuper = bonusLookupSeats seats y x
                                        tl = lookuper 1 (-1)
                                        tm = lookuper 1 0
                                        tr = lookuper 1 1
                                        ml = lookuper 0 (-1)
                                        mr = lookuper 0 1
                                        bl = lookuper (-1) (-1)
                                        bm = lookuper (-1) 0
                                        br = lookuper (-1) 1
                                        occupiedSeat (Just seat) = seat == '#'
                                        occupiedSeat _ = False
                                    in length $ filter occupiedSeat [tl, tm, tr, ml, mr, bl, bm, br]

bonusLookupSeats :: Seats -> Int -> Int -> Int -> Int -> Maybe Char
bonusLookupSeats seats y x vY vX
  | isJust seat = case seat of (Just '.')  -> bonusLookupSeats seats nextY nextX vY vX
                               (Just _)    -> seat
  | otherwise   = Nothing
  where nextY = y + vY
        nextX = x + vX
        row   = getByindex nextY seats
        seat  = case row of Just row -> getByindex nextX row
                            _        -> Nothing
