import Common
import Data.List (find)
import Data.Maybe (isJust)

main :: IO ()
main = do
  let result = solution $ readGame "inputs/22.test.input"
  print result

  let result = solution $ readGame "inputs/22.input"
  print result

  let result = bonusSolution $ readGame "inputs/22.test.input"
  print result

  let result = bonusSolution $ readGame "inputs/22.input"
  print result

type Deck = [Int]

readGame :: String -> (Deck, Deck)
readGame file = (map read $ tail deckA, map read $ tail deckB)
  where (deckA, deckB) = splitToTuple "" $ readLines file

-- Solution
solution decks = sum $ zipWith (*) result [length result, length result - 1..1]
  where result = play decks

play (deckA, []) = deckA
play ([], deckB) = deckB
play decks       = play $ game decks

game (a:deckA, b:deckB) | a > b = (deckA ++ [a, b], deckB)
                        | b > a = (deckA,           deckB ++ [b, a])
                        | otherwise = error "boom"

-- Bonus

type Decks = ([Int], [Int])
data State = State { history :: [Decks],
                     decks   :: Decks
                   }

bonusSolution decks = sum $ zipWith (*) result [length result, length result - 1..1]
  where state  = State [] decks
        result = case bonusPlay state of Left deck -> deck
                                         Right deck -> deck

bonusPlay (State _ (deckA, [])) = Left deckA
bonusPlay (State _ ([], deckB)) = Right deckB
bonusPlay state                 = bonusPlay $ bonusGame state

bonusGame (State history decks@(a:deckA, b:deckB))
  -- The recurse catch
  | inRecurse = recurseEndState
  -- The sub game rule
  | startSubGame = case subGameResult of Left  _ -> State newHistory (deckA ++ [a, b], deckB)
                                         Right _ -> State newHistory (deckA,           deckB ++ [b, a])
  -- The classic game rules
  | otherwise = State newHistory (game decks)
  where -- Subgame
        startSubGame  = length deckA >= a && length deckB >= b
        subGameState  = State [] (take a deckA, take b deckB)
        subGameResult = bonusPlay subGameState
        -- Recurse
        inRecurse       = isJust $ find (== decks) history
        recurseEndState = State [] (deckA, [])
        -- New states
        newHistory = decks : history
