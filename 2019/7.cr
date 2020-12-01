require "file"
require "./cpu"


input = File.read("7.input")

# test_input = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

result = (0..4).to_a.permutations.map do |permutation|
  permutation.reduce(0) do |output, phase|
    _, output = run(input, [phase, output])
    output.last
  end
end.max

p result