import Common
import Data.List (find, group, sort,transpose)

import Data.Map (Map)
import qualified Data.Map as Map

import Data.Maybe

import Debug.Trace

main :: IO ()
main = do
  let result = solution $ readImages "inputs/20.test.input"
  print result

  -- let result = solution $ readImages "inputs/20.input"
  -- print result

  let result = bonusSolution $ readImages "inputs/20.test.input"
  print result

  -- let result = bonusSolution $ readImages "inputs/20.input"
  -- print result

data Image = Image { imageId :: Int,
                     image :: [String],
                     edges :: [String],
                     borderCount :: Int
                   } deriving (Eq, Ord, Show)

type EdgeCounter = Map String Int

type Images = Map Int Image

readImages :: String -> Images
readImages file = Map.fromList $ map parseImage rawImages
  where lines     = readLines file
        rawImages = split "" lines
        allEdges  = concatMap (imageToEdges . tail) rawImages
        edgesCounter = Map.fromList $ map (\e -> (head e, length e)) $ group $ sort allEdges
        parseImage (header:image) = (imageId, Image imageId image edges bordersCount)
          where imageId       = read $ filter isDigit header
                edges         = imageToEdges image
                bordersCount  = length $ filter isBorder edges
                isBorder edge = edgesCounter Map.! edge == 1

imageToEdges :: [String] -> [String]
imageToEdges image = map (\e -> minimum [e, reverse e]) edges
  where edges = [topEdge image, bottomEdge image, rightEdge image, leftEdge image]

solution :: Images -> Int
solution images = product $ map imageId $ mapMaybe (`Map.lookup` collage) [Coord x y | x <- [1, sides], y <- [1, sides]]
  where sides   = getSides images
        collage = imagePositions images

getSides :: Map k a -> Int
getSides = round . sqrt . fromIntegral . Map.size

data Coord = Coord { x :: Int,
                     y :: Int
                   } deriving (Eq, Ord, Show)

type Collage = Map Coord Image
type FinalImage = Map Coord [String]

-- bonusSolution :: Images
bonusSolution images = stitchCollage collage
  where collage = imagePositions images

firstCoord  = Coord 1 1
rightCoord  = Coord 2 1
bottomCoord = Coord 1 2

stitchCollage :: Collage -> FinalImage
stitchCollage collage = final
  where initialState = placeInitial collage
        final        = placeNext collage sides initialState
        sides        = getSides collage

placeInitial :: Collage -> FinalImage
placeInitial collage = Map.fromList [(firstCoord, first), (rightCoord, right), (bottomCoord, bottom)]
  where unknownFirst = image $ collage Map.! firstCoord
        unknownRight  = image $ collage Map.! rightCoord
        unknownBottom  = image $ collage Map.! bottomCoord
        ((first, right, bottom):_) = [(first,right, bottom) |
                                      first <- imageVariants unknownFirst,
                                      right <- imageVariants unknownRight,
                                      rightEdge first == leftEdge right,
                                      bottom <- imageVariants unknownBottom,
                                      bottomEdge first == topEdge bottom]

placeNext :: Collage -> Int -> FinalImage -> FinalImage
placeNext collage sides final = foldl findNext final coords
  where coords = [Coord x y | x <- [1..sides], y <- [1..sides]]
        findNext final' coord@(Coord x y) = if Map.member coord final' then final'
                                                                       else updateImage collage final' coord

updateImage collage final coord@(Coord x y) = Map.insert coord finalImage final
  where unknownImage = image $ collage Map.! coord
        finalImage = if Map.member (Coord (x-1) y) final then matchImageToLeft unknownImage (final Map.! Coord (x-1) y)
                                                         else matchImageToTop unknownImage (final Map.! Coord x (y-1))

matchImageToLeft unknownImage imageOnLeft = finalImage
  where (finalImage:_) = [image | image <- imageVariants unknownImage, rightEdge imageOnLeft == leftEdge image]

matchImageToTop unknownImage imageOnTop = finalImage
  where (finalImage:_) = [image | image <- imageVariants unknownImage, bottomEdge imageOnTop == topEdge image]

topEdge :: [String] -> String
topEdge    = head

bottomEdge :: [String] -> String
bottomEdge = last

rightEdge :: [String] -> String
rightEdge  = map last

leftEdge :: [String] -> String
leftEdge   = map head

-- Find and place parts into right coords
imagePositions images = snd $ foldl (solveCoord sides) (images, Map.empty :: Collage) coords
  where sides   = getSides images
        coords  = [Coord x y | x <- [1..sides], y <- [1..sides]]

solveCoord :: Int -> (Images, Collage) -> Coord -> (Images, Collage)
solveCoord sides (images, collage) coord = case image of Just image -> (Map.delete (imageId image) images, Map.insert coord image collage)
                                                         Nothing    -> error "boom"
  where coordBorderCount = getCoordBorders sides coord
        neighboursCoords = getNeighboursCoords sides coord
        neighboursEdges  = concatMap edges $ mapMaybe (`Map.lookup` collage) neighboursCoords
        imageCandidates  = filter ((==coordBorderCount) . borderCount) $ Map.elems images
        image            = find findImage imageCandidates
        findImage Image {edges = edges'} = null neighboursEdges || any (`elem` neighboursEdges) edges'

getCoordBorders :: Int -> Coord -> Int
getCoordBorders sides (Coord x y) = length $ filter (\v -> v == 1 || v == sides) [x, y]

getNeighboursCoords :: Int -> Coord -> [Coord]
getNeighboursCoords sides coord@(Coord x y) = [Coord x' y' | x' <- [x-1..x+1], y' <- [y-1..y+1], Coord x' y' /= coord, x' >= 1, x' <= sides, y' >= 1, y' <= sides ]

-- Variations

imageVariants :: [String] -> [[String]]
imageVariants image = [image, image90, image180, image270,
                      flipImage image, flipImage image90, flipImage image180, flipImage image270]
  where image90  = rotateImage image
        image180 = rotateImage image90
        image270 = rotateImage image180

flipImage :: [String] -> [String]
flipImage = map reverse

rotateImage :: [String] -> [String]
rotateImage image = imap (\x row -> imap (\y _ -> image !! (maxI - y) !! x) row) image
  where maxI = length image - 1
