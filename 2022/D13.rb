input = File.readlines("inputs/D13.input")

DEBUG = false

puts "PART 1"
def compare(left, right, level = 0)
  nest = " " * (level * 2)
  nest2 = " " * ((level * 2) + 2)

  DEBUG && puts("#{nest}- Compare #{left} vs #{right}")

  case [left, right]
  in [Numeric => left, Numeric => right]
    if left == right
      nil
    elsif left < right
      DEBUG && puts("#{nest2}- Left side is smaller, so inputs are in the right order")
      return true
    else
      DEBUG && puts("#{nest2}- Right side is smaller, so inputs are not in the right order")
      return false
    end
  in [Array, Array]
    [left.size, right.size].max.times do |i|
      left_value = left[i]
      right_value = right[i]

      case [left_value, right_value]
      in [nil, _]
        DEBUG && puts("#{nest2}- Left side ran out of items, so inputs are in the right order")
        return true
      in [_, nil]
        DEBUG && puts("#{nest2}- Right side ran out of items, so inputs are not in the right order")
        return false
      else
        case compare(left_value, right_value, level + 1)
        when true
          return true
        when false
          return false
        end
      end
    end
  in [Array, Numeric => right]
    DEBUG && puts("#{nest2}- Mixed types; convert right to [#{right}] and retry comparison")
    compare left, [right], (level + 1)
  in [Numeric => left, Array]
    DEBUG && puts("#{nest2}- Mixed types; convert left to [#{left}] and retry comparison")
    compare [left], right, (level + 1)
  end
end

# correct = input.each_slice(3).map.with_index do |x, i|
#   p1,p2,_ = x

#   left = eval(p1)
#   right = eval(p2)

#   DEBUG && puts("\n== Pair #{i+1} ==")
#   if compare(left, right)
#     i + 1
#   else
#     nil
#   end
# end.select {_1}

# puts correct.reduce(:+)

puts "Part 2"

signals = input.select { _1.strip != "" }.map { eval(_1) }

SEPARATOR_1 = [[2]]
SEPARATOR_2 = [[6]]

signals << SEPARATOR_1
signals << SEPARATOR_2

sorted = signals.sort { |left, right| compare(left, right) ? -1 : 1 }

positions = sorted.map.with_index do |signal, i|
  if signal == SEPARATOR_1
    i + 1
  elsif signal == SEPARATOR_2
    i + 1
  end
end.compact

p positions.reduce(:*)
