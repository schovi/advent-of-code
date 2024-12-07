input = File.readlines("inputs/D21.input")

COMMANDS = {}
MATCHER = /([a-z]+): ([^\n]+)/

# Part 1

# input.each do |line|
#   MATCHER =~ line
#   key, value = $1, $2

#   if /\d+/ =~ value
#     COMMANDS[key] = value.to_i
#   else
#     left, operator, right = value.split(' ')

#     COMMANDS[key] = -> {
#       left_value = resolve(left)
#       right_value = resolve(right)
#       case operator
#       when '+'
#         left_value + right_value
#       when '-'
#         left_value - right_value
#       when '/'
#         left_value / right_value
#       when '*'
#         left_value * right_value
#       end
#      }
#   end
# end

# def resolve(key)
#   if COMMANDS[key].is_a?(Proc)
#     COMMANDS[key] = COMMANDS[key].call

#     return COMMANDS[key]
#   end

#   COMMANDS[key]
# end

# p resolve('root')


# Part 2

input.each do |line|
  MATCHER =~ line
  key, value = $1, $2

  if /\d+/ =~ value
    COMMANDS[key] = value.to_i
  else
    left, operator, right = value.split(' ')

    COMMANDS[key] = -> {
      left_value = resolve(left)
      right_value = resolve(right)
      case operator
      when '+'
        left_value + right_value
      when '-'
        left_value - right_value
      when '/'
        left_value / right_value
      when '*'
        left_value * right_value
      end
     }
  end
end

def resolve(key)
  if COMMANDS[key].is_a?(Proc)
    COMMANDS[key] = COMMANDS[key].call

    return COMMANDS[key]
  end

  COMMANDS[key]
end

p resolve('root')
