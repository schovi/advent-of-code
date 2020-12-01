require "file"

input = File.read("1.input")
masses = input.split('\n').map(&.to_i)

def fuel(mass)
  (mass / 3).floor - 2
end

result = masses.reduce(0) do |sum, mass|
  sum + fuel(mass)
end

p result