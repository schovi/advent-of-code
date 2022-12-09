import System.Environment
import System.IO
import Data.List
import Data.Function

main :: IO ()
main = do
  -- Import the `getArgs` function
  -- Get the input file name from the command line argument
  inputFileName <- getArgs
  -- Convert the list of strings to a single string
  let inputFileNameStr = unwords inputFileName
  -- Open the input file
  inputFile <- openFile inputFileNameStr ReadMode
  -- Read the input file line by line
  inputLines <- hGetContents inputFile
  let
    -- Convert each line to a list of characters
    chars = map (\s -> case uncons s of
                        Just (c, _) -> c
                        Nothing -> '\n') $ lines inputLines
    -- Group the characters by the newline character
    groups = groupBy (\x y -> x /= '\n') chars
    -- Convert each group to a string and then to a list of integers
    calories = map (map read . lines) . filter (not . null) . map (\g -> g ++ "\n") $ groups
    -- Sort the calorie lists by the sum of the calories in descending order
    caloriesByElf = sortBy (flip compare `on` sum) calories
    -- Take the top three calorie lists
    topThree = take 3 caloriesByElf
    -- Find the sum of the top three calorie lists
    totalCalories = sum $ map sum topThree
  -- Print the result
  print totalCalories
  -- Close the input file
  hClose inputFile
