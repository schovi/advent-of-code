require "file"
require "./cpu2"

FIELD_SPACE = 0_i64
FIELD_WALL  = 1_i64
FIELD_BLOCK = 2_i64
FIELD_PAD   = 3_i64
FIELD_BALL  = 4_i64

CHARS = {
  FIELD_SPACE => '.',
  FIELD_WALL  => 'X',
  FIELD_BLOCK => '#',
  FIELD_PAD   => '=',
  FIELD_BALL  => 'o'
}

SCREEN_WIDTH  = 36
SCORE_HEIGHT  = 2
SCREEN_HEIGHT = 21 + SCORE_HEIGHT
BUFFER_SIZE   = SCREEN_WIDTH * SCREEN_HEIGHT

def initialize_buffer
  Array(Char).new(BUFFER_SIZE, ' ')
end

def draw_line(buffer)
  SCREEN_WIDTH.times do |i|
    store_buffer(buffer, i, 21, '-')
  end
end

def draw_joystick(buffer, joystick)
  icon = case joystick
  when JOYSTICK_LEFT    then '\\'
  when JOYSTICK_NEUTRAL then '|'
  when JOYSTICK_RIGHT   then '/'
  end

  store_buffer(buffer, 18,  22, icon.not_nil!)
end

def draw_score(buffer, score)
  score.chars.reverse.each_with_index do |char, i|
    store_buffer(buffer, SCREEN_WIDTH - 1 - i, 22, char)
  end
end

def draw_dead(buffer)
  "dead".chars.each_with_index do |char, i|
    store_buffer(buffer, i, 22, char)
  end
end

def store_buffer(buffer, x, y, char)
  buffer[y * SCREEN_WIDTH + x] = char
end

# Clear and dump current buffer and enjoy the screen with sleep
def print_buffer(buffer)
  puts `clear`

  buffer.in_groups_of(SCREEN_WIDTH).each do |line|
    puts line.join
  end

  sleep SLEEP
end

JOYSTICK_LEFT    = -1_i64
JOYSTICK_NEUTRAL =  0_i64
JOYSTICK_RIGHT   =  1_i64

SLEEP            =  1

def run()
  # Start the program
  source = File.read("13.bonus.input")

  program = Program.new(source)
  program.start

  buffer = initialize_buffer
  draw_line(buffer)

  pad_x   = 0_i64
  ball_xs = { 0_i64, 0_i64 }

  game_started = false

  loop do
    x = program.read

    # Game enD
    unless x
      draw_dead(buffer)
      print_buffer(buffer)

      break
    end

    y = program.read.not_nil!
    tile = program.read.not_nil!

    # Score
    if x == -1
      game_started = true

      draw_score(buffer, tile.to_s)
    # Receiving changes
    else
      case tile
      when FIELD_PAD
        pad_x = x
      when FIELD_BALL
        ball_xs = [ball_xs[1], x]
      end

      store_buffer(buffer, x, y, CHARS[tile].not_nil!)
    end

    # Joystick control +
    if game_started
      ball_x = ball_xs[1]

      joystick_move = ball_x <=> pad_x

      ball_icon = case ball_xs[1] <=> ball_xs[0]
                  when -1 then '<'
                  when 1 then '>'
                  else '?'
                  end

      store_buffer(buffer, 10, 22, ball_icon)
      draw_joystick(buffer, joystick_move)
      print_buffer(buffer)

      program.write(joystick_move.to_i64)
    end
  end
end

run