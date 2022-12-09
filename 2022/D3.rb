# # # Parse the input and store it in a list of rucksacks
# rucksacks = [
#   "vJrwpWtwJgWrhcsFMMfFFhFp",
#   "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
#   "PmmdzqPrVvPwwTWBwg",
#   "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
#   "ttgJtRGJQctTZtZT",
#   "CrZsJsPPZsGzwwsLwLmpwMDw"
# ]

# Read the rucksacks from the input file
rucksacks = File.readlines("D3.input")

LOWERS = ('a'..'z').to_a
UPPERS = ('A'..'Z').to_a

def priority(char)
  if LOWERS.include?(char)
    char.ord - 'a'.ord + 1
  elsif UPPERS.include?(char)
    char.ord - 'A'.ord + 27
  else
    raise "X"
  end
end

result = rucksacks.map do |runsack|
  a, b = runsack.chars.partition.with_index {|_,index| index >= runsack.length/2 }
  priority((a & b).first)
end.sum

puts result

result2 = rucksacks.each_slice(3).map do |groups|
  priority(groups.map(&:chars).reduce(&:intersection).first)
end.sum

puts result2


# # Compute the priority of a given item type
# def priority(item_type)
#   # Return 0 if the item type is nil
#   return 0 if item_type.nil?

#   if item_type.match?(/[a-z]/)
#     return item_type.ord - "a".ord + 1
#   elsif item_type.match?(/[A-Z]/)
#     return item_type.ord - "A".ord + 27
#   else
#     raise "Invalid item type: #{item_type}"
#   end
# end

# # Find the item type that appears in both compartments of each rucksack
# common_item_types = rucksacks.map do |rucksack|
#   # Split the rucksack into its two compartments
#   comp1, comp2 = rucksack.chars.each_slice((rucksack.size + 1) / 2).to_a
#   # Find the items that appear in both compartments
#   (comp1 & comp2).find { |i| i != nil }
# end

# # Compute the sum of the priorities of the common item types
# sum_priorities = common_item_types.map { |item_type| priority(item_type) }.sum

# puts sum_priorities
