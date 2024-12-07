require 'pry'
input = File.readlines("inputs/D15.experiment.input")

SENSOR = 0
BEACON = 1
MISS = 2
CAVE = {}
STATE = {}
SENSORS = {}

MATCHER = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

PLANES = []
LINES = []

Point = Struct.new(:x, :y)
Line = Struct.new(:p1, :p2) do
  def inspect
    "Line p1[x:#{p1.x} y:#{p1.y}] p2[x:#{p2.x} y:#{p2.y}]"
  end

  def slope
    @slope ||= (p1.x - p2.x) / (p1.y - p2.y)
  end

  def intercept
    @intercept ||= p1.x - slope * p1.y
  end

  def intersection(other)
    # Calculate the intersection point of the lines
    slope_diff = slope - other.slope
    return if slope_diff == 0

    y = (other.intercept - intercept) / slope_diff
    x = slope * y + intercept

    intersection = Point.new(x, y)

    covers_point?(intersection) && other.covers_point?(intersection) ? intersection : nil
  end

  def covers_point?(point)
    [p1.x, p2.x].sort.include?(point.x) && [p1.y, p2.y].sort.include?(point.y)
  end
end

Sensor = Struct.new(:x, :y, :radius) do
  def covers_point?(point)

  end
end

SENSORS = []

input.each do |line|
  MATCHER =~ line

  sX, sY, bX, bY = [$1, $2, $3, $4].map(&:to_i)

  manhattan = (bX - sX).abs + (bY - sY).abs

  SENSORS << Sensor.new(sX, sY, manhattan)

  left    = Point.new(sX - manhattan, sY)
  left1   = Point.new(left.x - 1, left.y)
  right   = Point.new(sX + manhattan, sY)
  right1  = Point.new(right.x + 1, right.y)
  top     = Point.new(sX, sY - manhattan)
  top1    = Point.new(top.x, top.y - 1)
  bottom  = Point.new(sX, sY + manhattan)
  bottom1 = Point.new(bottom.x, bottom.y + 1)

  LINES << Line.new(Point.new(top.x + 1, top.y), right1)
  LINES << Line.new(bottom1, Point.new(right.x, right.y + 1))
  LINES << Line.new(left1, Point.new(bottom1.x - 1, bottom.y))
  LINES << Line.new(Point.new(left.x, left.y - 1), top1)
end

puts "Part 2"

MIN = 0
MAX = 20

POINTS = []


while LINES.any?
  line = LINES.pop

  p line
  LINES.each do |other_line|
    p "  #{other_line.inspect}"
    point = line.intersection(other_line)
    POINTS << point if point
  end
end


p POINTS
