require 'json'
input = File.readlines("inputs/D7.input")

fs = nil
current = nil

input.each do |line|
  case line.split(' ')
  in '$', 'cd', '/'
    # puts "creating root"
    fs = { type: :dir, name: '/', content: {}, parent: nil }
    current = fs
  in '$', 'cd', '..'
    # puts "going up from #{current[:name]} to #{current[:parent][:name]}"
    current = current[:parent]
  in '$', 'cd', dir
    # puts "going down to #{dir}"
    current = current[:content][dir]
  in '$', 'ls'
    # puts "ls current #{current[:name]}"
  in 'dir', name
    current[:content][name] = { type: :dir, name:, content: {}, parent: current }
  in /\d+/ => size, name
    current[:content][name] = { type: :file, name:, size: size.to_i }
  end
end

def compute_dir_size(dir)
  dir.delete(:parent)
  dir[:size] = dir[:content].map { |_, value| value[:type] == :dir ? compute_dir_size(value) : value[:size] }.sum
end

compute_dir_size(fs)

# puts JSON.pretty_generate(fs)

SIZE_LIMIT = 100_000

def collect_sizes(dir, output = [])
  dir[:content].values.reduce(output) do |acc, value|
    next acc unless value[:type] == :dir
    acc << value[:size]
    collect_sizes(value, acc)
  end
end

# puts(collect_sizes(fs).filter { |size| size <= SIZE_LIMIT }.sum)

sorted_sizes = collect_sizes(fs).sort

TOTAL_SPACE = 70000000
SPACE_FOR_UPDATE = 30000000
TAKEN = fs[:size]

puts (sorted_sizes.find do |size|
  TAKEN - size + SPACE_FOR_UPDATE <= TOTAL_SPACE
end)
