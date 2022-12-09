# Get the input file name from the command line argument
input_file = ARGV[0]

# Read the input file line by line
calories = File.readlines(input_file).map(&:to_i)

# Group the calories by Elf
calories_by_elf = calories.chunk { |c| c.zero? }.map(&:last)

# Sort the calorie lists by the sum of the calories in descending order
calories_by_elf = calories_by_elf.sort_by { |l| -l.sum }

# Take the top three calorie lists
top_three = calories_by_elf.take(3)

# Find the sum of the top three calorie lists
total_calories = top_three.map(&:sum).sum

# Print the result
puts total_calories
