{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Common
import Binary
import Debug.Trace
import Data.Char (digitToInt)

import qualified Data.Map as Map
import Data.Map (Map)

main :: IO ()
main = do
  let result = solution $ parseHexa $ head $ readLines "inputs/16.input"
  print result

data Packet = Packet
  { version :: Int
  , value :: Int
  } deriving (Eq, Ord, Read, Show)

type Version = Int
type ParseResult = (Packet, Bin)

solution = parsePacket

parsePacket :: Bin -> ParseResult
parsePacket (v1:v2:v3:id1:id2:id3:bin) = (Packet (totalVersion + version) value, rest)
  where (Packet totalVersion value, rest) = parsePacketId id bin
        version = fromBin [v1, v2, v3]
        id      = fromBin [id1, id2, id3]

parsePacketId :: Int -> Bin -> ParseResult
parsePacketId 4 = parseLiteral
parsePacketId id = parseOperator id

parseLiteral :: Bin -> ParseResult
parseLiteral bin = ( Packet 0 (fromBin numberBin), rest )
  where (numberBin, rest) = parseLiteral' bin

parseLiteral' (0:rest) = splitAt 4 rest
parseLiteral' (1:rest) = (take 4 rest ++ bin, nextPacket)
  where (bin, nextPacket) = parseLiteral' (drop 4 rest)

parseOperator :: Int -> Bin -> ParseResult
parseOperator id bin = (joinSubpackets id subpackets, rest)
  where (subpackets, rest) = parseOperatorSubpackets id bin

emptyPacket = Packet 0 0

joinSubpackets :: Int -> [Packet] -> Packet
joinSubpackets id packets = Packet versionsSum newValue
  where versionsSum = sum $ map version packets
        newValue    = performOperation id $ map value packets

performOperation :: Int -> [Int] -> Int
performOperation 0 values = sum values
performOperation 1 values = product values
performOperation 2 values = minimum values
performOperation 3 values = maximum values
performOperation 5 [value1,value2] = if value1 > value2 then 1 else 0
performOperation 6 [value1,value2] = if value1 < value2 then 1 else 0
performOperation 7 [value1,value2] = if value1 == value2 then 1 else 0
performOperation _ _ = error "invalid operation"

parseOperatorSubpackets :: Int -> Bin -> ([Packet], Bin)
parseOperatorSubpackets id (0:bin) = (parseSubpackets subpacketsBin, rest)
  where (subpacketsBin, rest) = splitAt length bin'
        length = fromBin lengthBin
        (lengthBin, bin') = splitAt 15 bin

parseOperatorSubpackets id (1:bin) = parseNSubpackets count bin'
  where count = fromBin countBin
        (countBin, bin') = splitAt 11 bin

parseSubpackets :: Bin -> [Packet]
parseSubpackets []  = []
parseSubpackets bin = packet : parseSubpackets rest
  where (packet, rest) = parsePacket bin

parseNSubpackets :: Int -> Bin -> ([Packet], Bin)
parseNSubpackets 0 rest = ([], rest)
parseNSubpackets count bin = (packet:packets, rest')
  where (packets, rest') = parseNSubpackets (count - 1) rest
        (packet, rest) = parsePacket bin

-- Parsing

hexaToBits = Map.fromList [ ('0',[0,0,0,0]),
                            ('1',[0,0,0,1]),
                            ('2',[0,0,1,0]),
                            ('3',[0,0,1,1]),
                            ('4',[0,1,0,0]),
                            ('5',[0,1,0,1]),
                            ('6',[0,1,1,0]),
                            ('7',[0,1,1,1]),
                            ('8',[1,0,0,0]),
                            ('9',[1,0,0,1]),
                            ('A',[1,0,1,0]),
                            ('B',[1,0,1,1]),
                            ('C',[1,1,0,0]),
                            ('D',[1,1,0,1]),
                            ('E',[1,1,1,0]),
                            ('F',[1,1,1,1])
                          ]

parseHexa = concatMap (hexaToBits Map.!)
