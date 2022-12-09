input = File.readlines("inputs/D8.input")
input.map! { _1.chars[..-2].map(&:to_i) }

def hidden_from_side?(input, tree, row, col, moveRow, moveCol)
  nextRow = row + moveRow
  return false if nextRow < 0 || nextRow >= input.size

  nextCol = col + moveCol
  return false if nextCol < 0 || nextCol >= input.first.size

  nextTree = input[nextRow][nextCol]

  if nextTree >= tree
    true
  else
    hidden_from_side?(input, tree, nextRow, nextCol, moveRow, moveCol)
  end
end

def hidden?(input, row, col)
  tree = input[row][col]

  unless hidden_from_side?(input, tree, row, col, -1, 0)
    # puts "visible from -1 0"
    return false
  end
  unless hidden_from_side?(input, tree, row, col, +1, 0)
    # puts "visible from 1 0"
    return false
  end
  unless hidden_from_side?(input, tree, row, col, 0, -1)
    # puts "visible from 0 -1"
    return false
  end
  unless hidden_from_side?(input, tree, row, col, 0, +1)
    # puts "visible from 0 1"
    return false
  end

  true
end

# counter = 0
# (1..input.size - 2).each do |row|
#   (1..input.first.size - 2).each do |col|
#     unless hidden?(input, row, col)
#       # puts "hidden #{row} #{col} tree = #{input[row][col]}"
#       counter += 1
#     end
#   end
# end

# counter += ((input.size * 2) + (input.first.size * 2) - 4)
# puts counter

####################
# Part 2

def directional_scenic_view_score(input, tree, row, col, moveRow, moveCol)
  nextRow = row + moveRow

  # p "XXX #{nextRow} >= #{input.size}  = #{nextRow >= input.size}"
  return 0 if nextRow < 0 || nextRow >= input.size

  nextCol = col + moveCol
  return 0 if nextCol < 0 || nextCol >= input.first.size

  nextTree = input[nextRow][nextCol]
  # puts "next #{nextRow} #{nextCol}, tree = #{nextTree}"

  if nextTree >= tree
    1
  else
    1 + directional_scenic_view_score(input, tree, nextRow, nextCol, moveRow, moveCol)
  end
end

def scenic_view_score(input, row, col)
  tree = input[row][col]

  directional_scenic_view_score(input, tree, row, col, -1, 0) *
  directional_scenic_view_score(input, tree, row, col, +1, 0) *
  directional_scenic_view_score(input, tree, row, col, 0, -1) *
  directional_scenic_view_score(input, tree, row, col, 0, +1)
end

max_score = 0

(0..input.size - 1).each do |row|
  (0..input.first.size - 1).each do |col|
    current_score = scenic_view_score(input, row, col)

    if current_score > max_score
      max_score = current_score
    end
  end
end

puts max_score
