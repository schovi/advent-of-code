input = File.readlines("inputs/D9.input")

HEAD = { x: 0, y: 0 }
TAIL = { x: 0, y: 0 }

VISITED_POSITIONS = { }

input.each do |line|
  direction, length = line.split(' ')
  length = length.to_i

  length.times do
    # puts
    case direction
    when 'U'
      HEAD[:y] += 1
    when 'R'
      HEAD[:x] += 1
    when 'D'
      HEAD[:y] -= 1
    when 'L'
      HEAD[:x] -= 1
    end

    diffX = HEAD[:x] - TAIL[:x]
    diffY = HEAD[:y] - TAIL[:y]
    # puts "Diff x=#{diffX} y=#{diffY}"

    case [diffX.abs, diffY.abs]
    in [2, 0] # moving straight X
      # puts "Moving straight X #{diffX / diffX.abs}"
      TAIL[:x] += diffX / diffX.abs
    in [0, 2] # moving straight Y
      # puts "Moving straight Y #{diffY / diffY.abs}"
      TAIL[:y] += diffY / diffY.abs
    in [2, 1] # moving diagonally
      # puts "Moving diagonaly X #{diffX / diffX.abs} Y #{diffY / diffY.abs}"
      TAIL[:x] += diffX / diffX.abs
      TAIL[:y] += diffY / diffY.abs
    in [1, 2] # moving diagonally
      # puts "Moving diagonaly X #{diffX / diffX.abs} Y #{diffY / diffY.abs}"
      TAIL[:x] += diffX / diffX.abs
      TAIL[:y] += diffY / diffY.abs
    in _
      nil
    end

    VISITED_POSITIONS["#{TAIL[:x]}x#{TAIL[:y]}"] ||= true

    # puts
    # printState
  end
end

puts "Visited positions: #{VISITED_POSITIONS.size}"

puts "PART 2"
# Part 2



HEAD = { x: 0, y: 0 }
ROPE = [HEAD]
9.times do
  ROPE << HEAD.dup
end

def printState
  maxX = 6
  maxY = 5

  maxY.times do |y|
    y = (maxY-1) - y

    puts
    maxX.times do |x|
      found = ROPE.find.with_index do |node, index|
        if node[:x] == x && node[:y] == y
          print index == 0 ? 'H' : index
          break true
        end
      end

      unless found
        print '.'
      end

      # if HEAD[:x] == x && HEAD[:y] == y
      #   print 'H'
      # elsif TAIL[:x] == x && TAIL[:y] == y
      #   print 'T'
      # # elsif VISITED_POSITIONS["#{x}x#{y}"]
      # #   print '#'
      # # elsif y == 0 && x == 0
      # #   print 's'
      # else
      #   print '.'
      # end
    end
  end
end

VISITED_POSITIONS = { }

input.each do |line|
  direction, length = line.split(' ')
  length = length.to_i

  length.times do
    # puts
    case direction
    when 'U'
      HEAD[:y] += 1
    when 'R'
      HEAD[:x] += 1
    when 'D'
      HEAD[:y] -= 1
    when 'L'
      HEAD[:x] -= 1
    end

    index = 0
    ROPE.reduce do |head, tail|
      index += 1
      diffX = head[:x] - tail[:x]
      diffY = head[:y] - tail[:y]

      case [diffX.abs, diffY.abs]
      in [2, 0] # moving straight X
        # puts "Moving straight X #{diffX / diffX.abs}" if index == 5
        tail[:x] += diffX / diffX.abs
      in [0, 2] # moving straight Y
        # puts "Moving straight Y #{diffY / diffY.abs}" if index == 5
        tail[:y] += diffY / diffY.abs
      in [2, 1] # moving diagonally
        # puts "Moving diagonaly X #{diffX / diffX.abs} Y #{diffY / diffY.abs}" if index == 5
        tail[:x] += diffX / diffX.abs
        tail[:y] += diffY / diffY.abs
      in [1, 2] # moving diagonally
        # puts "Moving diagonaly X #{diffX / diffX.abs} Y #{diffY / diffY.abs}" if index == 5
        tail[:x] += diffX / diffX.abs
        tail[:y] += diffY / diffY.abs
      in [2, 2] # moving diagonally
        tail[:x] += diffX / diffX.abs
        tail[:y] += diffY / diffY.abs
      in _
        nil
      end

      tail
    end

    tail = ROPE.last
    VISITED_POSITIONS["#{tail[:x]}x#{tail[:y]}"] ||= true
  end
end

puts
puts
puts "Visited positions: #{VISITED_POSITIONS.size}"
