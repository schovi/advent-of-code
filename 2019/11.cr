require "file"
require "./cpu2"

LIMIT = 20000
PAUSE = 0

alias Color  = Int64
alias Facing = Int64
alias Coords = { x: Int64, y: Int64 }
alias Map    = Hash(Coords, Color)

# Colors
BLACK = 0_i64
WHITE = 1_i64

# Facing
UP    = 0_i64
RIGHT = 1_i64
DOWN  = 2_i64
LEFT  = 3_i64

def move_forward(position, facing)
  case facing
  when UP
    position.merge(y: position[:y] - 1)
  when RIGHT
    position.merge(x: position[:x] + 1)
  when DOWN
    position.merge(y: position[:y] + 1)
  when LEFT
    position.merge(x: position[:x] - 1)
  else
    raise "🤯"
  end
end

def draw(*, map, position, facing, iteration)
  puts `clear`

  (-30_i64..30_i64).each do |y|
    x = (-50_i64..50_i64).map do |x|
      coords = { x: x, y: y }

      if coords == position
        "#{facing}"
        case facing
        when UP    then '^'
        when RIGHT then '>'
        when DOWN  then 'v'
        when LEFT  then '<'
        end
      else
        if color = map[coords]?
          "#{color == BLACK ? ' ' : '#'}"
        else
          " "
        end
      end
    end

    puts x.join()
  end
end

def run(facing, color = BLACK)
  # Start the program
  source = File.read("11.input")
  program = Program.new(source)
  program.start

  iteration = 0

  # { x, y }
  position = { x: 0_i64, y: 0_i64 }

  # Hash where keys are coords and value the color. Missing position is always black
  map = Map.new()# { |hash, key| hash[key] = BLACK }

  if color
    map[position] = color
  end

  loop do
    sleep PAUSE if iteration > 0 && PAUSE > 0

    if (iteration % 10) == 0
      draw(
        map: map,
        position: position,
        facing: facing,
        iteration: iteration
      )
    end

    # Send color from sensor to robot
    current_color = map[position]? || BLACK
    program.write(current_color)

    # Read new color and paint the board
    new_color = program.read
    break if new_color.nil?
    map[position] = new_color

    # 0 turn 90 degree LEFT
    # 1 turn 90 degree RIGHT
    turning = program.read
    break if turning.nil?
    facing = (facing + (turning == 1 ? 1 : -1)) % 4
    position = move_forward(position, facing)

    iteration += 1
  end

  map
end

map = run(UP)
p map.size

# run(UP, WHITE)