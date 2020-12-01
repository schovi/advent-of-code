def run
  min = "277777" # originally 272091, but due to never decreased numbers we can improve it
  max = "799999" # originally 815432, -||-

  count = 0
  ('2'..'7').each do |a|
    (a..'9').each do |b|
      (b..'9').each do |c|
        (c..'9').each do |d|
          (d..'9').each do |e|
            (e..'9').each do |f|
              num = "#{a}#{b}#{c}#{d}#{e}#{f}"

              if num >= min && (a == b || b == c || c == d || d == e || e == f)
                count += 1
              end
            end
          end
        end
      end
    end
  end

  count
end

p run