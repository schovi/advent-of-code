require "file"
require "./cpu2"

source = File.read("9.input")

program = Program.new(source)

program.start

program.write(1_i64)

while x = program.read
  p x
end
