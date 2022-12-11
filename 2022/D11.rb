require 'json'
input = File.readlines("inputs/D11.input")

MONKEYS = {}
last_monkey = nil

input.each do |line|
  case line
  when /Monkey (\d+)/
    last_monkey = {
      inspected: 0
    }
    MONKEYS[$1.to_i] = last_monkey
  when /Starting items: (.+)/
    last_monkey[:next_items] = $1.split(',').map(&:to_i)
  when /Operation: new = (.*)/
    last_monkey[:operation] = eval "->(old) {#{$1}}"
  when /Test: divisible by (.*)/
    last_monkey[:test] = $1.to_i
  when /If (true|false): throw to monkey (\d+)/
    last_monkey[:branches] ||= {}
    last_monkey[:branches][$1 == 'true'] = $2.to_i
  else
    nil
  end
end

# # Part 1
# puts "Part 1"

# 20.times do |round|
#   # puts "Round #{round + 1}"
#   MONKEYS.each do |i, monkey|
#     # puts "  Monkey #{i}:"
#     monkey[:inspected] += monkey[:items].size

#     monkey[:items].each do |old|
#       # puts "    Item level #{old}."
#       new_worry_level = eval(monkey[:operation]) / 3

#       # puts "    Next level #{new_worry_level}"

#       next_monkey = monkey[:branches][(new_worry_level % monkey[:test]) == 0]
#       # "      Thrown to monkey #{next_monkey}"
#       MONKEYS[next_monkey][:items] << new_worry_level
#     end

#     monkey[:items] = []
#   end
# end

# Part 2
puts "Part 2"

MODULO = (2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29)

def move_item(round, current_monkey_id, old)
  # puts "#{round} monkey #{current_monkey_id} inspecting #{old}"
  monkey = MONKEYS[current_monkey_id]
  monkey[:inspected] += 1

  new_level = monkey[:operation].call(old) # / 3 # Part one
  # puts "  New level #{new_level}"
  new_level = new_level % MODULO
  next_monkey_id = monkey[:branches][(new_level % monkey[:test]) == 0]

  if next_monkey_id <= current_monkey_id
    # puts "    Kept for next round #{next_monkey_id}"
    MONKEYS[next_monkey_id][:next_items] << new_level
  else
    # puts "    Next monkey inspecting #{next_monkey_id}"
    move_item(round, next_monkey_id, new_level)
  end
end

10_000.times do |round|
  puts "Round #{round}"
  MONKEYS.each do |_, monkey|
    monkey[:items] = monkey[:next_items]
    monkey[:next_items] = []
  end

  # puts "Round #{round + 1}"
  MONKEYS.each do |i, monkey|
    monkey[:items].each do |level|
      move_item(round, i, level)
    end
  end
end

MONKEYS.each do |i, monkey|
  puts "Monkey #{i} inspected items #{monkey[:inspected]} times."
end

a, b = MONKEYS.map do |_, monkey|
  monkey[:inspected]
end.sort.reverse[0..1]

puts (a*b)
