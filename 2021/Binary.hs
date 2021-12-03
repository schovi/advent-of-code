module Binary where

type Bin = [Int]

toBin 0 = [0]
toBin n = reverse (toBin' n)

toBin' 0 = []
toBin' n | x == 1 = 1 : toBin' (n `div` 2)
         | x == 0 = 0 : toBin' (n `div` 2)
  where x = n `mod` 2

fromBin :: Bin -> Int
fromBin (1:xs) = 2 ^ length xs + fromBin xs
fromBin (0:xs) = 0 + fromBin xs
fromBin []       = 0

zipMask :: Num b => [Char] -> [b] -> [(Char, b)]
zipMask a b = reverse $ zipMask' 'X' 0 (reverse a) (reverse b)

zipMask' :: a -> b -> [a] -> [b] -> [(a,b)]
zipMask' a b (x:xs) (y:ys) = (x,y) : zipMask' a b xs ys
zipMask' a _ []     ys     = zip (repeat a) ys
zipMask' _ b xs     []     = zip xs (repeat b)
