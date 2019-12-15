require "file"

require "./cpu"

memory, _ = run(File.read("2.input"))

p memory[0]