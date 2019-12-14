require "file"

def draw_wire(map, crossings, wire)
  position = {0, 0}

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

    map[position] = true

    while length > 0
      position = {position[0] + x, position[1] + y}

      if map[position]?
        crossings[position] = true
      end

      map[position] = true

      length -= 1
    end
  end
end

def find_closest_crossing(crossings)
  crossings.map do |crossing, _|
    x, y = crossing

    x.abs + y.abs
  end.min
end

def run
  input = File.read("3.input")

  wire1, wire2 = input.split('\n').map do |wire|
    wire.split(',').map do |coord|
      {coord[0], coord[1..-1].to_i}
    end
  end

  map = {} of Tuple(Int32, Int32) => Bool
  crossings = {} of Tuple(Int32, Int32) => Bool

  draw_wire(map, crossings, wire1)
  draw_wire(map, crossings, wire2)

  find_closest_crossing(crossings)
end

p run