# Read the rounds from the file
rounds = File.read("D2.input")

# Initialize the player's total score
total_score = 0

# Play the rounds from the file
rounds.each_line do |line|
  # Parse each line of the rounds
  opponent_move, player_move = line.strip.split(" ")

  # Calculate the outcome of the round
  if (player_move == "X" && opponent_move == "A") ||
    (player_move == "Y" && opponent_move == "B") ||
    (player_move == "Z" && opponent_move == "C")
    # It's a draw, add 3 to the player's score
    total_score += 3
  elsif (player_move == "Y" && opponent_move == "A") ||
        (player_move == "Z" && opponent_move == "B") ||
        (player_move == "X" && opponent_move == "C")
    # The player wins, add 6 to their score
    total_score += 6
  end

  # Add the score of the player's move to the player's total score
  total_score += player_move == "X" ? 1 : (player_move == "Y" ? 2 : 3)
end

# Print the player's total score
puts total_score



# Initialize the player's total score
total_score = 0
LOOSE = 'X'
DRAW = 'Y'
WIN = 'Z'

# Play the rounds from the file
rounds.each_line do |line|
  # Parse each line of the rounds
  opponent_move, player_move = line.strip.split(" ")

  # Calculate the outcome of the round
  if player_move == DRAW
    # It's a draw, add 3 to the player's score
    total_score += 3
    total_score += {
      'A' => 1,
      'B' => 2,
      'C' => 3
    }[opponent_move]
  elsif player_move == WIN
    # The player wins, add 6 to their score
    total_score += 6

    total_score += {
      'A' => 2,
      'B' => 3,
      'C' => 1
    }[opponent_move]
  else
    total_score += {
      'A' => 3,
      'B' => 1,
      'C' => 2
    }[opponent_move]
  end
end

# Print the player's total score
puts total_score
