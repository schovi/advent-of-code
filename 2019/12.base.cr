def load_system(source)
  source.lines.map do |line|
    x, y, z = line[1..-2].split(", ").map do |coord|
      coord.split('=')[1].to_i
    end

    {
      position: { x: x, y: y, z: z },
      velocity: { x: 0, y: 0, z: 0 }
    }
  end
end

def compute_velocity(system)
  system.map do |object|
    position = object[:position]
    new_velocity = system.reduce(object[:velocity]) do |velocity, other|
      next velocity if object == other

      {
        x: velocity[:x] + (other[:position][:x] <=> position[:x]),
        y: velocity[:y] + (other[:position][:y] <=> position[:y]),
        z: velocity[:z] + (other[:position][:z] <=> position[:z]),
      }
    end

    object.merge(
      velocity: new_velocity
    )
  end
end

def apply_velocity(system)
  system.map do |object|
    position = object[:position]
    velocity = object[:velocity]

    object.merge(
      position: {
        x: position[:x] + velocity[:x],
        y: position[:y] + velocity[:y],
        z: position[:z] + velocity[:z],
      }
    )
  end
end

def nice_num(num)
  "#{num}".rjust(3, ' ')
end

def nice_coords(coords)
  "x=#{nice_num(coords[:x])}, y=#{nice_num(coords[:y])}, z=#{nice_num(coords[:z])}"
end

def print_debug(system)
  system.each do |object|
    position = object[:position]
    velocity = object[:velocity]

    puts "pos=<#{nice_coords(position)}>, vel=<#{nice_coords(velocity)}>"
  end
end

def calculate_total_energy(system)
  system.map do |object|
    potential = object[:position].values.reduce(0) { |total, val| total + val.abs }
    kinetic   = object[:velocity].values.reduce(0) { |total, val| total + val.abs }

    potential * kinetic
  end.sum
end
