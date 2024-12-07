input = File.readlines("inputs/D14.input")

ROCK = 0
SAND = 1
INIT_CAVE = {}
STATE = { min_y: 0 }

input.each do |line|
  coords = line.split(' -> ')
  coords.map! { _1.split(',').map(&:to_i) }

  coords.reduce do |from, to|
    x1, y1 = from
    x2, y2 = to

    ([x1,x2].min..[x1, x2].max).each do |x|
      if !STATE[:min_x] || x < STATE[:min_x]
        STATE[:min_x] = x
      end

      if !STATE[:max_x] || x > STATE[:max_x]
        STATE[:max_x] = x
      end

      ([y1,y2].min..[y1, y2].max).each do |y|
        if !STATE[:max_y] || y > STATE[:max_y]
          STATE[:max_y] = y
        end

        INIT_CAVE[[x, y]] = ROCK
      end
    end

    to
  end
end

ABYSS_THRESHOLD = 10_000

CAVE = INIT_CAVE.dup

def run
  sand_counter = 0

  catch :abyss do
    loop do
      sand = [500, 0]

      abyss = 0

      loop do
        if abyss > ABYSS_THRESHOLD
          puts "abyss threshold reached after #{sand_counter} sands"
          throw :abyss
        end

        # try down
        unless CAVE[[sand[0], sand[1] + 1]]
          sand[1] += 1
          abyss += 1
          next
        end

        # try left down
        unless CAVE[[sand[0] - 1, sand[1] + 1]]
          sand[0] -= 1
          sand[1] += 1
          abyss = 0
          next
        end

        # try right down
        unless CAVE[[sand[0] + 1, sand[1] + 1]]
          sand[0] += 1
          sand[1] += 1
          abyss = 0
          next
        end

        CAVE[sand] = SAND

        break
      end

      sand_counter += 1
    end
  end
end

run

BONUS_CAVE = INIT_CAVE.dup
BONUS_STATE = STATE.dup
new_bottom = BONUS_STATE[:max_y] + 2
BONUS_STATE[:max_y] = new_bottom
BONUS_STATE[:min_x] = STATE[:min_x] - new_bottom
BONUS_STATE[:max_x] = STATE[:max_x] + new_bottom

((STATE[:min_x] - new_bottom)..(STATE[:max_x] + new_bottom)).each do |x|
  BONUS_CAVE[[x, new_bottom]] = ROCK
end

SAND_INIT = [500, 0]

def run_bonus
  sand_counter = 0

  catch :stable do
    loop do
      sand = SAND_INIT.dup
      sand_counter += 1

      loop do
        # try down
        unless BONUS_CAVE[[sand[0], sand[1] + 1]]
          sand[1] += 1
          next
        end

        # try left down
        unless BONUS_CAVE[[sand[0] - 1, sand[1] + 1]]
          sand[0] -= 1
          sand[1] += 1
          next
        end

        # try right down
        unless BONUS_CAVE[[sand[0] + 1, sand[1] + 1]]
          sand[0] += 1
          sand[1] += 1
          next
        end

        BONUS_CAVE[sand] = SAND

        if sand == SAND_INIT
          puts "stable after #{sand_counter} sands"
          throw :stable
        end

        break
      end
    end

    break
  end
end

def print_cave(cave, state)
  (state[:min_y]..state[:max_y]).each do |y|
    (state[:min_x]..state[:max_x]).each do |x|
      case cave[[x, y]]
      when ROCK
        print '#'
      when SAND
        print 'o'
      else
        print '.'
      end
    end

    puts
  end
end

run_bonus
