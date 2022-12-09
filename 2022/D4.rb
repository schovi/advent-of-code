input = File.readlines("inputs/D4.input")

def make_range(plan)
  Range.new(*plan.split("-").map(&:to_i))
end

counter = 0

input.each do |line|
  plan1, plan2 = line.split(',')
  range1 = make_range(plan1)
  range2 = make_range(plan2)

  if range1.cover?(range2) || range2.cover?(range1)
    counter += 1
  end
end

puts counter

counter = 0

input.each do |line|
  plan1, plan2 = line.split(',')
  range1 = make_range(plan1).to_a
  range2 = make_range(plan2).to_a

  if range1.intersect?(ranger2)
    counter += 1
  end
end

puts counter
