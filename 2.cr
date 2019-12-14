require "file"

def step(program, cursor)
  opcode = program[cursor]

  if opcode == 99
    :done
  elsif opcode == 1 || opcode == 2
    position_a = program[cursor + 1]
    position_b = program[cursor + 2]
    position_write  = program[cursor + 3]

    value_a = program[position_a]
    value_b = program[position_b]

    program[position_write] = if opcode == 1
      value_a + value_b
    else
      value_a * value_b
    end
  else
    raise "unknown opcode #{opcode} at #{cursor}"
  end
end


def run
  input = File.read("2.input")

  program = input.split(',').map(&.to_i)
  cursor = 0

  # Correction
  program[1] = 12
  program[2] = 2

  while step(program, cursor) != :done
    cursor = cursor + 4
  end

  program[0]
end


p run