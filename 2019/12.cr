require "./12.base"

def run(steps, source)
  system = load_system(source)

  steps.times do
    system = compute_velocity(system)
    system = apply_velocity(system)
  end

  puts "After #{steps} steps:"
  print_debug(system)

  total = calculate_total_energy(system)
  puts
  puts total
end

source = File.read("12.input")

# source = "<x=-1, y=0, z=2>
# <x=2, y=-10, z=-7>
# <x=4, y=-8, z=8>
# <x=3, y=5, z=-1>"

# source = "<x=-8, y=-10, z=0>
# <x=5, y=5, z=10>
# <x=2, y=-7, z=3>
# <x=9, y=-8, z=-3>"

run(1000, source)