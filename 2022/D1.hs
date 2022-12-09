import System.IO

main :: IO ()
main = do
  -- Open the input file
  inputFile <- openFile "input.txt" ReadMode
  -- Read the input file line by line
  inputLines <- hGetContents inputFile
  let
    -- Convert each line to an integer and add it to a list of calories
    -- If the line is empty, create a new list for the next Elf's food items
    calories = map (map read . lines) . groupBy (\x y -> x /= "") . lines $ inputLines
  -- Find the sum of the maximum calorie list
  let maxCalories = maximum $ map sum calories
  -- Print the result
  print maxCalories
  -- Close the input file
  hClose inputFile
