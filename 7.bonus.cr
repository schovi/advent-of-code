require "file"
require "./cpu2"


source = File.read("7.input")

solution = (5..9).to_a.permutations.map do |amplifiers_setting|
  programs = amplifiers_setting.map do |setting|
    Program.new(source, "program #{setting}").tap do |program|
      program.start
      program.write(setting)
    end
  end

  result = 0

  programs.cycle do |program|
    program.write(result)

    output = program.read

    break unless output

    result = output
  end

  result
end.max

p solution