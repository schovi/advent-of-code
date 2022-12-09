input = File.readlines("inputs/D6.input")


input.each do |line|
  chars = line.chars

  index = 14

  while true
    current = chars[index-14...index]

    if current == current.uniq
      puts index
      break
    end

    index += 1
  end
end
