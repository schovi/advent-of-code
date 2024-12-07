input = File.readlines("inputs/D16.test.input")

matcher = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([^\n]+)/

GRAPH = {}

input.each do |line|
  matcher =~ line

  GRAPH[$1] = {
    rate: $2.to_i,
    tunnels: $3.split(', ')
  }
end

JOBS = [['AA', GRAPH.dig('AA', :tunnels, 0)]]

timer = 30

loop do
  timer -= 1

  from, to = JOBS.shift

  rate = GRAPH.dig(to, :rate)

  next if rate == 0

  # we can open

  # we can move
end
