

line1 = Line.new(Point.new(3,0), Point.new(6,3))

# Thru
line_thru = Line.new(Point.new(0,7), Point.new(7,0))
# Inside
line_inside = Line.new(Point.new(2,3), Point.new(4,1))
# Partial
line_partial = Line.new(Point.new(4,5), Point.new(7,2))
# Outside
line_outside = Line.new(Point.new(4,7), Point.new(6,5))



top = Point.new(3,0)
right = Point.new(6,3)
bottom = Point.new(3,6)
left = Point.new(0,3)

plane = Plane.new(
  [
    Line.new(left, top),
    Line.new(bottom, right),
    Line.new(left, bottom),
    Line.new(top, right)
  ]
)

i = Intersection.new(Line.new(Point.new(0,5), Point.new(1,4)), plane)
