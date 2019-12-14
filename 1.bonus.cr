require "file"

input = File.read("1.input")
masses = input.split('\n').map(&.to_i)

def compute_fuel(mass)
  needed_fuel = (mass / 3).floor - 2

  return 0 if needed_fuel <= 0

  needed_fuel + compute_fuel(needed_fuel)
end

result = masses.reduce(0) do |sum, mass|
  sum + compute_fuel(mass)
end

p result