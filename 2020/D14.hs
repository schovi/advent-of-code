import Common
import Binary
import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
  print "Test:"
  let result = solution $ readWords "inputs/14.test.input"
  print result

  print "Regular:"
  let result = solution $ readWords "inputs/14.input"
  print result

type Input  = [[String]]
type Memory = Map Int Int
type Binary = [Int]
type Mask   = String

solution :: Input -> Int
solution lines = sum $ Map.elems memory
-- solution lines = memory
  where memory = readWrite Map.empty "" lines

readWrite :: Memory -> Mask -> Input -> Memory
readWrite mem _ []                                  = mem
readWrite mem _ (("mask":_:mask:_):program)         = readWrite mem mask program
readWrite mem mask ((memAddress:_:value:_):program) = readWrite newMem mask program
  where address    = read $ filter (`elem` ['0'..'9']) memAddress
        newMem     = updateMemory mem address mask ((toBin . read) value)

updateMemory :: Memory -> Int -> Mask -> Binary -> Memory
updateMemory memory address mask valueBin = Map.insert address newValue memory
  where newValue = fromBin $ applyMask mask valueBin

applyMask mask value = map applyMask $ zipMask mask value
  where applyMask ('X', x) = x
        applyMask ('0', _) = 0
        applyMask ('1', _) = 1
