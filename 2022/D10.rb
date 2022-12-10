input = File.readlines("inputs/D10.input")

MEASURE_AT = [20, 60, 100, 140, 180, 220]

STATE = {
  clocks: 0,
  registry: 1,
  strength: 0,
}

def tick
  clocks = STATE[:clocks] + 1
  STATE[:clocks] = clocks

  # puts "Clocks: #{clocks}, Registry: #{STATE[:registry]}"

  if MEASURE_AT.include?(clocks)
    signal = STATE[:registry] * clocks
    STATE[:strength] += signal
    # puts "signal #{signal} #{STATE[:strength]}"
  end

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
      STATE[:registry] += x.to_i
    end
  end
end

puts STATE[:strength]
