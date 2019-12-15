def read_value(memory, cursor, parameter, modes)
  position = memory[cursor + parameter]

  if modes[parameter] == '0'
    memory[position]
  else
    position
  end
end

def write_value(memory, cursor, parameter, value)
  memory[memory[cursor + parameter]] = value
end

def run(memory, prompt = [] of Int32)
  memory = memory.split(',').map(&.to_i)
  output = [] of Int32
  cursor = 0

  while
    instruction = memory[cursor]
    opcode      = instruction % 100
    parsed      = instruction.to_s.chars
    modes       = {
      nil,
      parsed[-3]? || '0',
      parsed[-4]? || '0',
      parsed[-5]? || '0'
    }

    case opcode
    when 1
      value = read_value(memory, cursor, 1, modes) + read_value(memory, cursor, 2, modes)
      write_value(memory, cursor, 3, value)

      cursor += 4
    when 2

      value = read_value(memory, cursor, 1, modes) * read_value(memory, cursor, 2, modes)
      write_value(memory, cursor, 3, value)

      cursor += 4
    when 3
      # Lets fake user input 🤷🏻‍♂️
      value = prompt.shift

      unless value
        raise "missing prompt value"
      end

      write_value(memory, cursor, 1, value)

      cursor += 2
    when 4
      # Print output
      output << read_value(memory, cursor, 1, modes)

      cursor += 2
    when 5 # jump-if-true
      if read_value(memory, cursor, 1, modes) != 0
        cursor = read_value(memory, cursor, 2, modes)
      else
        cursor += 3
      end
    when 6 # jump-if-false
      if read_value(memory, cursor, 1, modes) == 0
        cursor = read_value(memory, cursor, 2, modes)
      else
        cursor += 3
      end
    when 7 # less than
      if read_value(memory, cursor, 1, modes) < read_value(memory, cursor, 2, modes)
        write_value(memory, cursor, 3, 1)
      else
        write_value(memory, cursor, 3, 0)
      end

      cursor += 4
    when 8 # equals
      if read_value(memory, cursor, 1, modes) == read_value(memory, cursor, 2, modes)
        write_value(memory, cursor, 3, 1)
      else
        write_value(memory, cursor, 3, 0)
      end

      cursor += 4
    when 99
      break
    else
      raise "unknown opcode #{opcode} at #{cursor} instruction #{instruction}"
    end
  end

  return memory, output
end