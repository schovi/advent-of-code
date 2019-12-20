require "./12.base"

def run(steps, source)
  initial = system = load_system(source)

  iteration = 0

  loop do
    iteration += 1
    system = compute_velocity(system)
    system = apply_velocity(system)

    break if system == initial

    if iteration % 100000 == 0
      puts `clear`
      puts iteration
    end
  end

  puts iteration
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