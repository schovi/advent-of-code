import Common

import Data.List (find)

import Data.Maybe (fromJust)

main :: IO ()
main = do
  let result = solution 5764801 17807724
  print result

  let result = solution 9232416 14144084
  print result

  let result = bonusSolution 1
  print result

  let result = bonusSolution 1
  print result

modNum  = 20201227
subject = 7

solution cardPublicKey doorPublicKey = iterate calculateEncryptionKey 1 !! loopKey
  where loopKey                      = findLoopKey cardPublicKey
        calculateEncryptionKey value = (value * doorPublicKey) `mod` modNum

findLoopKey cardPublicKey = fst . fromJust . find ((==cardPublicKey) . snd) $ iterate iterator (0, 1)
  where iterator (loop, value) = (loop + 1, (value * subject) `mod` modNum)

bonusSolution = id
