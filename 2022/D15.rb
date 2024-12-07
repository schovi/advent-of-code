input = File.readlines("inputs/D15.test.input")

SENSOR = 0
BEACON = 1
MISS = 2
CAVE = {}
STATE = {}
SENSORS = {}

MATCHER = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

input.each do |line|
  MATCHER =~ line

  sX, sY, bX, bY = [$1, $2, $3, $4].map(&:to_i)

  manhattan = (bX - sX).abs + (bY - sY).abs
  SENSORS[[sX, sY]] = {
    beacon: [bX, bY],
    manhattan:
  }

  minX, maxX = [sX - manhattan, sX + manhattan].sort
  minY, maxY = [sX - manhattan, sY + manhattan].sort

  STATE[:min_x] = minX if !STATE[:min_x] || minX < STATE[:min_x]
  STATE[:max_x] = maxX if !STATE[:max_x] || maxX > STATE[:max_x]
  STATE[:min_y] = minY if !STATE[:min_y] || minY < STATE[:min_y]
  STATE[:max_y] = maxY if !STATE[:max_y] || maxY > STATE[:max_y]

  CAVE[[sX, sY]] = SENSOR
  CAVE[[bX, bY]] = BEACON
end

def print_cave(cave, state)
  (state[:min_y]..state[:max_y]).each do |y|
    (state[:min_x]..state[:max_x]).each do |x|
      case cave[[x, y]]
      when SENSOR
        print 'S'
      when BEACON
        print 'B'
      when MISS
        print '#'
      else
        print '.'
      end
    end

    puts
  end
end

#print_cave(CAVE, STATE)#.merge(max_y: 22, max_x: 25))

# # Detect for any point if there is a signal coverage.
# # Signal coverage is computed if the point is in a range of any sensor
# # Sensor has signal of manhattan length between itself and its beacon
# # Signal is all around the sensor
# def detect_signal_presence(coord, sensor, data)
#   beacon = data[:beacon]
#   manhattan = data[:manhattan]

#   # check if coord is in range of sensor
#   if (sensor[0] - coord[0]).abs + (sensor[1] - coord[1]).abs <= manhattan
#     true
#   else
#     false
#   end
# end

def detect_signal_in_row(y)
  misses = {}

  (STATE[:min_x]..STATE[:max_x]).to_a.each do |x|
    coord = [x, y]

    if CAVE[coord]
      next
    end

    SENSORS.each do |sensor, data|
      beacon = data[:beacon]
      manhattan = data[:manhattan]

      # check if coord is in range of sensor
      if (sensor[0] - coord[0]).abs + (sensor[1] - coord[1]).abs <= manhattan
        CAVE[coord] = MISS
        misses[coord] ||= true
      end
    end
  end

  misses.size
end

puts "Part 1"

(STATE[:min_y]..STATE[:max_y]).each do |y|
  detect_signal_in_row(y)
end

print_cave(CAVE, STATE.merge(min_y: 10, max_y: 12, min_x: 10, max_x: 20))

puts "Part 2"

MIN = 0
MAX = 4000000
