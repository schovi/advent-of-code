input = File.readlines("inputs/D15.test.input")

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
  def slope
    @slope ||= (p1.x - p2.x) / (p1.y - p2.y)
  end

  def intercept
    @intercept ||= p1.x - slope * p1.y
  end

  def with_plane(plane)
    Intersection.new(self, plane)
  end

  def intersection(other)
    # Calculate the intersection point of the lines
    y = (other.intercept - intercept) / (slope - other.slope)
    x = slope * y + intercept

    intersection = Point.new(x, y)

    covers_point?(intersection) && other.covers_point?(intersection) ? intersection : nil
  end

  def covers_point?(point)
    [p1.x, p2.x].sort.include?(point.x) && [p1.y, p2.y].sort.include?(point.y)
  end
end

Sensor = Struct.new(:x, :y, :radius) do

end

Plane = Struct.new(:lines) do
  def lines_against_slope(line)
    lines.select { |plane_line| plane_line.slope != line.slope }
  end
end

# Intersection = Struct.new(:line, :plane) do
#   def plane_lines
#     @plane_lines ||= plane.lines_against_slope(line)
#   end

#   def left_plane_line
#     plane_lines[0]
#   end

#   def right_plane_line
#     plane_lines[1]
#   end

#   def left_intersection
#     @left_intersection ||= line.intersection(left_plane_line)
#   end

#   def right_intersection
#     @right_intersection ||= line.intersection(right_plane_line)
#   end

#   def outside?
#     # top
#     line.p1.y < right_intersection.y ||
#     # bottom
#     line.p2.y > left_intersection.y ||
#     # rigth
#     right_intersection.x > line.p1.x ||
#     # left
#     left_intersection.x < line.p2.x
#   end

#   def within?
#     left_plane_line.p1.x <= line.p1.x && line.p1.x <= right_plane_line.p2.x &&
#     left_plane_line.p2.y >= line.p1.y && line.p1.y >= right_plane_line.p1.y &&
#     left_plane_line.p1.x <= line.p2.x && line.p2.x <= right_plane_line.p2.x &&
#     left_plane_line.p2.y >= line.p2.y && line.p2.y >= right_plane_line.p1.y
#   end

#   def left_line

#   end

#   def right_line

#   end
# end

input.each do |line|
  MATCHER =~ line

  sX, sY, bX, bY = [$1, $2, $3, $4].map(&:to_i)

  manhattan = (bX - sX).abs + (bY - sY).abs

  left    = Point.new(sX - manhattan, sY)
  left1   = Point.new(left.x - 1, left.y)
  right   = Point.new(sX + manhattan, sY)
  right1  = Point.new(right.x + 1, right.y)
  top     = Point.new(sX, sY - manhattan)
  top1    = Point.new(top.x, top.y - 1)
  bottom  = Point.new(sX, sY + manhattan)
  bottom1 = Point.new(bottom.x, bottom.y + 1)

  PLANES << [Line.new(left, top), Line.new(bottom, right), Line.new(left, bottom), Line.new(top, right)]

  # PLANES << { -1 => [Line.new(left, top), Line.new(bottom, right)], 1 => [Line.new(left, bottom), Line.new(top, right)] }

  LINES << Line.new(bottom1, right1)
  LINES << Line.new(left1,   top1)
  LINES << Line.new(top1,    right1)
  LINES << Line.new(left1,   bottom1)
end

puts "Part 2"

MIN = 0
MAX = 20

while LINES.any?
  line_parts = [LINES.pop]

  catch :skip do
    PLANES.each do |plane|
      # plane_p1, plane_p2, plane_p3, plane_p4 = plane

      line_parts = line_parts.flat_map do |line|
        line = line_parts.pop

        intersection = Intersection.new(line, plane)

        # Removing the line from the pipeline
        if intersection.within?
          throw :skip
        end

        # Skip and process next plane
        if intersection.outside?
          next line
        end

        [intersection.left_line, intersection.right_line].compact
      end
    end
  end
end



      10,10

5,15        20, 15

10 - 15 / 10 - 20
0,5 => 5 y intercept

10 - 15 / 10 - 15
1

-1

10 - 15 / 10 - 5
