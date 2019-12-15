require "file"

struct Planet
  property name : String
  property parent : String
  property planets = Array(Planet).new
  property dictionary : Hash(String, Planet)

  def initialize(@dictionary, @name, @parent)
  end

  def parent
    dictionary[@parent]?
  end

  def parents
    parents = [] of Planet

    if parent
      parents << parent.not_nil!
      parents.concat(parent.not_nil!.parents)
    end

    parents
  end
end

def run(input)
  list = Hash(String, Planet).new

  input.split('\n').map do |orbit|
    com, object = orbit.split(')')

    planet = list[object] ||= Planet.new(list, object, com)

    planet.planets.push(planet)
  end

  you   = list["YOU"]
  santa = list["SAN"]

  you_parents   = you.parents.map(&.name)
  santa_parents = santa.parents.map(&.name)

  you_to_crossing_length = 0
  santa_to_crossing_length = 0

  santa_parents.find do |you_parent|
    you_to_crossing_length += 1
    santa_to_crossing_length = 0

    you_parents.find do |santa_parent|
      santa_to_crossing_length += 1
      you_parent == santa_parent
    end
  end

  p (you_to_crossing_length + santa_to_crossing_length - 2)
end

run(File.read("6.input"))

# input = "COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# K)YOU
# I)SAN"

# run(input)
