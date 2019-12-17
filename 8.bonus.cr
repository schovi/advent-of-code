require "file"

input = File.read("8.input")

wide_pixels = 25
tall_pixels = 6

layer_pixels = wide_pixels * tall_pixels

layers = input.chars.map(&.to_i).in_groups_of(layer_pixels, 0)

# 0 is black, 1 is white, and 2 is transparent.
result = layers.reduce do |result, layer|
  result.map_with_index do |a, i|
    a == 2 ? layer[i] : a
  end
end

puts result.map { |a| a == 0 ? ' ' : '#' }
           .in_groups_of(wide_pixels)
           .map(&.join)
           .join('\n')