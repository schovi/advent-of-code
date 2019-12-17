require "file"

input = File.read("8.input")

wide_pixels = 25
tall_pixels = 6

layer_pixels = wide_pixels * tall_pixels

layers = input.chars.map(&.to_i).in_groups_of(layer_pixels)

zeros_count = layers.map(&.select(0)).map(&.size)

layer = layers[zeros_count.index(zeros_count.min).not_nil!]

result = layer.select(1).size * layer.select(2).size

p "Solution 8"
p result