require "file"

def draw_wire(map, wire)
  position = {0, 0}
  steps    = 0

  wire.each do |move|
    direction, length = move

    x = 0
    y = 0

    case direction
    when 'U'
      y = 1
    when 'R'
      x = 1
    when 'D'
      y = -1
    when 'L'
      x = -1
    end

    map[position] = steps

    while length > 0
      position = {position[0] + x, position[1] + y}
      steps += 1
      map[position] = steps

      length -= 1
    end
  end
end

def find_closest_crossing(map1, map2)
  crossings = (map1.keys & map2.keys) - [{0,0}]

  crossings.map do |crossing|
    steps1 = map1[crossing]
    steps2 = map2[crossing]

    steps1 + steps2
  end.min
end

def run
  input = File.read("3.input")

  wire1, wire2 = input.split('\n').map do |wire|
    wire.split(',').map do |coord|
      {coord[0], coord[1..-1].to_i}
    end
  end

  map1 = {} of Tuple(Int32, Int32) => Int32
  map2 = {} of Tuple(Int32, Int32) => Int32

  draw_wire(map1, wire1)
  draw_wire(map2, wire2)

  find_closest_crossing(map1, map2)
end

p run