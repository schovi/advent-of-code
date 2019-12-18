require "./10"

def vector_to_angle(x, y)
  rad = Math.atan(x.abs / y.abs)
  deg = rad * 180 / Math::PI
  deg
end

#              ∠0
#
#    -1,-1     -1     -1,1
#               |
#        x      |
# ∠270  -1 --- 0,0 --- 1  ∠90
#               |
#               |
#  1,-1       y 1      1,1
#
#             ∠180
def compute_angle(x, y)
  if x == 0
    y > 0 ? 180 : 0
  elsif y == 0
    x > 0 ? 90 : 270
  elsif x > 0 && y < 0 # top right quadrant
    vector_to_angle(x, y)
  elsif x > 0 && y > 0 # bottom right quadrant
    180 - vector_to_angle(x, y)
  elsif x < 0 && y > 0 # bottom left quadrant
    180 + vector_to_angle(x, y)
  elsif x < 0 && y < 0 # top left quadrant
    360 - vector_to_angle(x, y)
  else
    raise "🤯 typesafe"
  end
end

# Pythagoras :D
def compute_distance(x, y)
  Math.sqrt(x ** 2 + y ** 2)
end

def enrich_asteroids(asteroids, asteroid)
  asteroids.map do |other|
    next if asteroid == other

    x = other[:x] - asteroid[:x]
    y = other[:y] - asteroid[:y]

    {
      angle:    compute_angle(x, y).round(2),
      asteroid: other,
      distance: compute_distance(x, y).round(2),
      vector:   { x: x, y: y } # For debugging purposes
    }
  end.compact
end

def shoot_them_until(asteroid, asteroids, max_shots)
  targets = enrich_asteroids(asteroids, asteroid)

  shots_counter = 0

  targets.sort_by(&.[:angle])
         .group_by(&.[:angle]) # .size gives me same number as 10.cr ❤️
         .values
         .map(&.sort_by(&.[:distance]))
        #  .tap { |x| p(x) }
         .cycle do |asteroids|
           next if asteroids.empty?
           next unless asteroid = asteroids.shift
           shots_counter += 1

           count_text = "#{shots_counter}.".ljust(4, ' ')

           break asteroid if shots_counter == max_shots
         end
end

def run_bonus
  input = File.read("10.input")

#   # {x: 11, y: 13}
#   input =".#..##.###...#######
# ##.############..##.
# .#.######.########.#
# .###.#######.####.#.
# #####.##.#.##.###.##
# ..#####..#.#########
# ####################
# #.####....###.#.#.##
# ##.#################
# #####.##.###..####..
# ..######..##.#######
# ####.##.####...##..#
# .#####..#.######.###
# ##...#.##########...
# #.##########.#######
# .####.#.###.###.#.##
# ....##.##.###..#####
# .#.#.###########.###
# #.#.#.#####.####.###
# ###.##.####.##.#..##"

  asteroids = parse_input(input)

  asteroid, _ = find_best_asteroid(asteroids)

  asteroid_data = shoot_them_until(asteroid, asteroids, 200)

  asteroid = asteroid_data[:asteroid]

  p asteroid
  p asteroid[:x] * 100 + asteroid[:y]
end

p "bonus"
run_bonus
