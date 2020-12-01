require "file"
require "./cpu2"

def run()
  # Start the program
  source = File.read("13.input")
  program = Program.new(source)
  program.start

  counter = 0
  loop do
    # drop x and y
    break unless program.read
    break unless program.read

    tile = program.read
    break unless tile

    counter += 1 if tile == 2
  end

  p counter
end

run