# Get the input file name from the command line argument
input_file = ARGV[0]

# Read the input file line by line
calories = File.readlines(input_file).map(&:to_i)

# Group the calories by Elf
calories_by_elf = calories.chunk { |c| c.zero? }.map(&:last)

# Find the sum of the maximum calorie list
max_calories = calories_by_elf.max_by(&:sum).sum

# Print the result
puts max_calories
