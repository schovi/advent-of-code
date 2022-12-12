input = File.readlines("inputs/D12.input")

ROWS = input.length
COLUMNS = input.first.length

def each_2d_array(input, &block)
  rows = input.length
  columns = input.first.length

  rows.times do |row|
    columns.times do |column|
      yield row, column
    end
  end
end

STATE = {
  start: nil,
  end: nil
}

each_2d_array(input) do |row, column|
  char = input[row][column]
  case char
  when "S"
    STATE[:start] = [row, column]
    input[row][column] = 'a'
  when "E"
    STATE[:end] = [row, column]
    input[row][column] = 'z'
  end
end

# Part 1
puts "Part 1"
DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]]
COSTS = { STATE[:start] => 0 }
TO_VISIT = [STATE[:start]]

DEBUG = false

while TO_VISIT.any?
  current_coord = TO_VISIT.shift
  current_value = input[current_coord[0]][current_coord[1]]
  current_cost = COSTS[current_coord]

  DEBUG && puts("Visiting: #{current_coord.join(',')} '#{current_value}' cost: #{current_cost}")

  DIRECTIONS.each do |row, column|
    next_y = current_coord[0] + row
    next if next_y < 0 || next_y >= ROWS

    next_x = current_coord[1] + column
    next if next_x < 0 || next_x >= COLUMNS

    next_coord = [next_y, next_x]
    next_value = input[next_coord[0]][next_coord[1]]

    DEBUG && puts("  Testing: #{next_coord.join(',')} '#{next_value}'")

    if next_value.ord > current_value.ord + 1
      DEBUG && puts("    Skipping: too high")
      next
    end

    next_cost = COSTS[next_coord]

    if !next_cost || next_cost > (current_cost + 1)
      DEBUG && puts("    Visiting later with #{current_cost + 1}")
      COSTS[next_coord] = current_cost + 1
      TO_VISIT.push(next_coord)
    else
      DEBUG && puts("    Skipping: visited cheaply")
    end
  end
end

p COSTS[STATE[:end]]


# Part 2
puts "Part 2"
COSTS = { STATE[:end] => 0 }
TO_VISIT = [STATE[:end]]

DEBUG = false

while TO_VISIT.any?
  current_coord = TO_VISIT.shift
  current_value = input[current_coord[0]][current_coord[1]]
  current_cost = COSTS[current_coord]

  DEBUG && puts("Visiting: #{current_coord.join(',')} '#{current_value}' cost: #{current_cost}")

  DIRECTIONS.each do |row, column|
    next_y = current_coord[0] + row
    next if next_y < 0 || next_y >= ROWS

    next_x = current_coord[1] + column
    next if next_x < 0 || next_x >= COLUMNS

    next_coord = [next_y, next_x]
    next_value = input[next_coord[0]][next_coord[1]]

    DEBUG && puts("  Testing: #{next_coord.join(',')} '#{next_value}'")

    if next_value.ord < current_value.ord - 1
      DEBUG && puts("    Skipping: too low")
      next
    end

    next_cost = COSTS[next_coord]

    if !next_cost || next_cost > (current_cost + 1)
      DEBUG && puts("    Visiting later with #{current_cost + 1}")
      COSTS[next_coord] = current_cost + 1
      TO_VISIT.push(next_coord)
    else
      DEBUG && puts("    Skipping: visited cheaply")
    end
  end
end

all_low = COSTS.select { |coord, _| input[coord[0]][coord[1]] == 'a' }
puts all_low.values.sort.first
