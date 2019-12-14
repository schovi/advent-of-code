require "file"

def step(program, cursor)
  instruction = program[cursor]
  parsed      = instruction.chars

  opcode = parsed[-1..-2].to_i
  mode_1 = parsed[-3]? ? parsed[-3].to_i : 0
  mode_2 = parsed[-4]? ? parsed[-4].to_i : 0
  mode_3 = parsed[-5]? ? parsed[-5].to_i : 0

  p opcode

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

    4
  elsif opcode == 3
    p "opcode 3"
    2
  elsif opcode == 4
    p "opcode 4"

    2
  else
    raise "unknown opcode #{opcode} at #{cursor}"
  end
end


def run
  input = File.read("5.input")

  program = input.split(',')
  cursor = 0

  while
    result = step(program, cursor)
    break if result == :done
    cursor += result
  end

  program[0]
end


p run