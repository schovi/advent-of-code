input = File.read(File.join(__DIR__, "input"))

matcher = /([a-z\-]+)\-(\d+)\[([a-z]+)\]/

data = input.split('\n').map do |line|
  result = matcher.match(line).not_nil!
  
  { 
    encryption: result[1],
    value: result[2].to_i,
    checksum: result[3] 
  }
end

def sort(data)
  data.to_a.sort do |(char1, val1), (char2, val2)|
    if val1 == val2
      char1 - char2
    else
      val2 - val1
    end
  end
end

def valid?(room)
  memory = {} of Char => Int32

  room[:encryption].each_char do |letter|
    if letter != '-'
      memory[letter] ||= 0
      memory[letter] += 1
    end
  end

  sorted_memory = sort(memory)

  decryption = sorted_memory[0..4].map(&.[0]).join()

  decryption == room[:checksum]
end

p data.reduce(0) do |sum, room|
  if valid?(room)
    sum += room[:value]
  else
    sum
  end
end