alias Input  = Channel(Int32)
alias Output = Channel(Int32)

class Program
  property memory : Array(Int32)
  getter cursor = 0
  getter input  = Input.new
  getter output = Output.new
  getter name

  def initialize(program : String, @name : String)
    @memory = program.split(',').map(&.to_i)

  end

  def read
    output.receive
  rescue Channel::ClosedError
    nil
  end

  def write(value)
    # Non blocking input ❤️
    spawn input.send(value)
  end

  def start
    loop
  end

  private def loop
    spawn do
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
          value = read_parameter(1, modes) + read_parameter(2, modes)
          write_parameter(3, value)

          @cursor += 4
        when 2

          value = read_parameter(1, modes) * read_parameter(2, modes)
          write_parameter(3, value)

          @cursor += 4
        when 3
          write_parameter(1, input.receive)

          @cursor += 2
        when 4
          output.send(read_parameter(1, modes))

          @cursor += 2
        when 5 # jump-if-true
          if read_parameter(1, modes) != 0
            @cursor = read_parameter(2, modes)
          else
            @cursor += 3
          end
        when 6 # jump-if-false
          if read_parameter(1, modes) == 0
            @cursor = read_parameter(2, modes)
          else
            @cursor += 3
          end
        when 7 # less than
          if read_parameter(1, modes) < read_parameter(2, modes)
            write_parameter(3, 1)
          else
            write_parameter(3, 0)
          end

          @cursor += 4
        when 8 # equals
          if read_parameter(1, modes) == read_parameter(2, modes)
            write_parameter(3, 1)
          else
            write_parameter(3, 0)
          end

          @cursor += 4
        when 99
          output.close

          break
        else
          raise "unknown opcode #{opcode} at #{cursor} instruction #{instruction}"
        end
      end
    end
  end

  def read_parameter(parameter, modes)
    position = memory[cursor + parameter]

    if modes[parameter] == '0'
      memory[position]
    else
      position
    end
  end

  def write_parameter(parameter, value)
    memory[memory[cursor + parameter]] = value
  end

  def initialize_memory(input : String)
    input.split(',').map(&.to_i)
  end
end
