input = File.read(File.join(__DIR__, "input"))

instructions = input.split("\n").map { |line| line.split(//).map(&.char_at(0)) }

keypad = {
  { 1, 2, 3},
  { 4, 5, 6},
  { 7, 8, 9},
}

# x, y
position = {0, 1}

code = instructions.map do |moves|
  position = moves.reduce(position) do |position, move|
    x, y = position

    case move
    when 'U'
      y = y == 0 ? 0 : y - 1
    when 'R'
      x = x == 2 ? 2 : x + 1
    when 'D'
      y = y == 2 ? 2 : y + 1
    when 'L'
      x = x == 0 ? 0 : x - 1
    end

    if keypad[y][x] != nil
      {x, y}
    else
      position
    end
  end

  keypad[position[1]][position[0]]
end

p code.join