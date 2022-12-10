input = File.readlines("inputs/D10.input")

STATE = {
  clocks: 0,
  x: 1,
  render: []
}

def tick
  puts
  clocks = STATE[:clocks]

  x = STATE[:x]
  sprite = [x-1, x, x+1]

  row = (clocks / 40.0).floor
  column = clocks % 40
  # puts "Sprite position #{sprite.join(',')}"

  if sprite.include?(column)
    STATE[:render][row] ||= []
    STATE[:render][row][column] = true
  end

  STATE[:clocks] = clocks + 1

  # puts "Clocks: #{clocks}, Registry: #{STATE[:x]}"

  yield if block_given?
end

input.each do |line|
  case line.split(' ')
  in ['noop']
    tick
  in ['addx', x]
    tick
    tick do
      # puts "Adding #{x}"
      STATE[:x] += x.to_i
    end
  end
end


6.times do |row|
  40.times do |column|
    print (STATE[:render][row][column] ? '#' : ' ')
  end
  print "\n"
end
