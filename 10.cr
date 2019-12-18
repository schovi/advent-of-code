require "file"

alias Asteroid = { x: Int32, y: Int32 }

def normalize_vector(asteroid, other)
  x = other[:x] - asteroid[:x]
  y = other[:y] - asteroid[:y]

  gcd = x.gcd(y)

  x = x / gcd
  y = y / gcd

  { x: x, y: y }
end

def compute_asteroid(asteroids, asteroid)
  asteroids.map do |other|
    next if other == asteroid

    normalize_vector(asteroid, other)
  end.compact.uniq.size
end

def parse_input(input)
  input.split('\n').map(&.chars).map_with_index do |line, y|
    line.map_with_index do |character, x|
      character == '#' ? { x: x, y: y } : nil
    end
  end.flatten.compact
end

def find_best_asteroid(asteroids)
  counts = {} of Asteroid => Int32

  asteroids.each do |asteroid|
    count = compute_asteroid(asteroids, asteroid)

    counts[asteroid] = count
  end

  counts.max_by { |_, count| count }
end

def run
  input = File.read("10.input")

#   input = ".#..##.###...#######
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

  asteroid, count = find_best_asteroid(asteroids)

  p asteroid
  p count
end

p "base"
run