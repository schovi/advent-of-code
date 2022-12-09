input = File.readlines("inputs/D5.input")

stacks = []

MOVE_MATCH = /move (\d+) from (\d+) to (\d+)/
#
# input.each do |line|
#   case line[0]
#   when '[', ' '
#     i = 1
#     number = 1
#     while char = line[i]
#       if ('A'..'Z').include?(char)
#         stacks[number] ||= []
#         stacks[number].unshift(char)
#       end
#       i += 4
#       number += 1
#     end
#   when 'm'
#     count, from, to = MOVE_MATCH.match(line).to_a[1..].map(&:to_i)
#
#     move = stacks[from].pop(count)
#     stacks[to].concat(move.reverse)
#   end
# end
#
# puts (stacks[1..].map do |stack|
#   stack.last
# end.join(''))

# bonus

stacks = []

input.each do |line|
  case line[0]
  when '[', ' '
    i = 1
    number = 1
    while char = line[i]
      if ('A'..'Z').include?(char)
        stacks[number] ||= []
        stacks[number].unshift(char)
      end
      i += 4
      number += 1
    end
  when 'm'
    count, from, to = MOVE_MATCH.match(line).to_a[1..].map(&:to_i)

    move = stacks[from].pop(count)
    stacks[to].concat(move)
  end
end

puts (stacks[1..].map do |stack|
  stack.last
end.join(''))
