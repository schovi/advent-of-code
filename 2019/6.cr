require "file"

def visit_planets(list, planet, orbits)
  return orbits unless list[planet]?

  planets = list[planet]

  total = planets.reduce(0) do |acc, planet|
    acc + visit_planets(list, planet, orbits + 1)
  end

  orbits + total
end

def run(input)
  list = Hash(String, Array(String)).new

  input.split('\n').map do |orbit|
    com, object = orbit.split(')')

    planet = list[com] ||= Array(String).new

    planet.push(object)
  end

  count = visit_planets(list, "COM", 0)

  p count
end

run(File.read("6.input"))
