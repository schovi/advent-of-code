import Common
import Binary
import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
  print "Bonus Test:"
  let result = bonusSolution $ readWords "inputs/14.bonus.test.input"
  print result

  print "Bonus:"
  let result = bonusSolution $ readWords "inputs/14.input"
  print result

type Input  = [[String]]
type Memory = Map Int Int
type Mask   = String

bonusSolution :: Input -> Int
bonusSolution lines = sum $ Map.elems memory
-- solution lines = memory
  where memory = readWrite Map.empty "" lines

readWrite :: Memory -> Mask -> Input -> Memory
readWrite mem _ []                                  = mem
readWrite mem _ (("mask":_:mask:_):program)         = readWrite mem mask program
readWrite mem mask ((memAddress:_:value:_):program) = readWrite newMem mask program
  where address    = toBin . read $ filter (`elem` ['0'..'9']) memAddress
        newMem     = updateMemory mem address mask (read value)

updateMemory :: Memory -> Bin -> Mask -> Int -> Memory
updateMemory memory address mask value = foldl updater memory combinations
  where updater mem addr = Map.insert addr value mem
        combinations = generateCombinations mask address

generateCombinations :: Mask -> Bin -> [Int]
generateCombinations mask rawAddress = fromBin <$> visit mask address [[]]
  where
    address = snd <$> zipMask mask rawAddress
    visit [] _ l = l
    visit _ [] l = l
    visit ('0' : m) (x : xs) l = visit m xs $ (x :) <$> l
    visit ('1' : m) (_ : xs) l = visit m xs $ (1 :) <$> l
    visit ('X' : m) (_ : xs) ls = visit m xs $ [x : l | x <- [0, 1], l <- ls]
