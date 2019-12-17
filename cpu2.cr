alias Input  = Channel(Int64)
alias Output = Channel(Int64)

class Program
  getter memory : Array(Int64)

  getter cursor : Int64         = 0
  getter relative_base : Int64  = 0

  getter input  = Input.new
  getter output = Output.new

  getter name

  def initialize(program : String, @name : String | Nil = nil)
    chars = program.split(',')

    # 1024 is empty working space in memory
    @memory = Array(Int64).new(chars.size + 1024, 0)

    chars.each_with_index do |value, i |
      @memory[i] = value.to_i64
    end
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
          write_parameter(3, value, modes)

          @cursor += 4
        when 2

          value = read_parameter(1, modes) * read_parameter(2, modes)
          write_parameter(3, value, modes)

          @cursor += 4
        when 3
          write_parameter(1, input.receive, modes)

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
            write_parameter(3, 1_i64, modes)
          else
            write_parameter(3, 0_i64, modes)
          end

          @cursor += 4
        when 8 # equals
          if read_parameter(1, modes) == read_parameter(2, modes)
            write_parameter(3, 1_i64, modes)
          else
            write_parameter(3, 0_i64, modes)
          end

          @cursor += 4
        when 9 # adjust relative base
          @relative_base += read_parameter(1, modes)

          @cursor += 2
        when 99
          output.close

          break
        else
          raise "unknown opcode #{opcode} at #{cursor} instruction #{instruction}"
        end
      end
    end
  end

  def read_parameter(index, modes)
    parameter = memory[cursor + index]

    case modes[index]
    when '0'
      memory[parameter]
    when '1'
      parameter
    when '2'
      memory[parameter + relative_base]
    else
      raise "Invalid mode"
    end
  end

  def write_parameter(index, value, modes)
    parameter = memory[cursor + index]

    case modes[index]
    when '0'
      memory[parameter] = value
    when '2'
      memory[parameter + relative_base] = value
    else
      raise "Invalid mode"
    end
  end
end
