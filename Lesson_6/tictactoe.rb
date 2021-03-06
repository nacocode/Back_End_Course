WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # column
                [[1, 5, 9], [3, 5, 7]] # diagnals

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WHO_GOES_FIRST = "choose" # Valid options:"player", "computer", or "choose".
WIN_AMOUNT = 5

def clear_screen
  system "clear"
end

def prompt(msg)
  puts "=> #{msg}"
end

def error_msg
  prompt "That's not a valid input."
end

def extra_line(number = 1)
  number.times do
    puts
  end
end

def display_score(score)
  extra_line(2)
  puts "«SCORE» PLAYER(X) | #{score['player']} - " \
       "#{score['computer']} | COMPUTER(O)"
  extra_line
end

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  clear_screen
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  extra_line(2)
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  extra_line
end
# rubocop: enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter = ', ', word = 'or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

def greeting
  prompt "——————————————————————————————————————————————————————
   Welcome to TIC TAC TOE!\n
   First player who wins #{WIN_AMOUNT} times becomes the Grand winner!\n
   Are you ready??
   ———————————————————————————————————————————————————————"
  extra_line
  prompt "Hit the Enter key to begin the game!"

  gets
end

def choose_first_player
  clear_screen
  prompt "Who goes first?"
  letter = ""
  loop do
    prompt "Enter 'p' for player or 'c' for computer."
    letter = gets.chomp.downcase
    break if ["p", "c"].include?(letter)
    error_msg
  end
  return "player" if letter == "p"
  return "computer" if letter == "c"
end

def first_player
  if WHO_GOES_FIRST == "choose"
    choose_first_player
  elsif WHO_GOES_FIRST == "player"
    "player"
  else
    "computer"
  end
end

def integer?(input)
  input.to_i.to_s == input
end

def place_piece!(brd, current_player)
  if current_player == "player"
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def player_places_piece!(brd)
  square = ""
  loop do
    extra_line
    prompt "Choose a position to place a piece:
    (#{joinor(empty_squares(brd))})"
    square = gets.chomp
    break if integer?(square) && empty_squares(brd).include?(square.to_i)
    error_msg
  end
  square = square.to_i
  brd[square] = PLAYER_MARKER
end

def find_at_risk_squere(line, brd, maker)
  if brd.values_at(*line).count(maker) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def get_mark_at_risk_square(brd, maker)
  square = nil

  WINNING_LINES.each do |line|
    square = find_at_risk_squere(line, brd, maker)
    break if square
  end

  square
end

def computer_places_piece!(brd)
  # offense first
  square = get_mark_at_risk_square(brd, COMPUTER_MARKER)

  # defense
  if !square
    square = get_mark_at_risk_square(brd, PLAYER_MARKER)
  end

  # pick square #5 if it's available
  square = 5 if brd[5] == INITIAL_MARKER

  # just pick a square ramdomly
  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def alternate_player(current_player)
  current_player == "player" ? "computer" : "player"
end

def board_full?(brd)
  empty_squares(brd).empty?
  # means : board is full
  # also can be witten >> empty_squares(brd) == []
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "computer"
    end
  end
  nil
end

def display_winner(winner)
  extra_line
  prompt "#{winner.capitalize} won this round!"
end

def keep_score(score, winner)
  if winner == "player"
    score["player"] += 1
  elsif winner == "computer"
    score["computer"] += 1
  end
end

def grand_winner?(score)
  score.value?(WIN_AMOUNT)
end

def next_game?(msg)
  answer = nil
  loop do
    extra_line
    prompt "#{msg}? Enter 'y' for yes or 'n' for no."
    answer = gets.chomp.downcase
    break if %w(yes y no n).include?(answer)
    error_msg
  end

  answer.start_with?("y")
end

def display_grand_winner?(score)
  if score.key(WIN_AMOUNT) == "player"
    prompt "You won #{WIN_AMOUNT} times! Congratulations! " \
    "You are the Grand Winner!!!"
  elsif score.key(WIN_AMOUNT) == "computer"
    prompt "Computer won #{WIN_AMOUNT} times. Game over."
  end
end

def display_goodbye
  extra_line
  prompt "Thanks for playing Tic Tac Toe! Good bye!"
end

# Starting a game
clear_screen
greeting

loop do
  score = { "player" => 0, "computer" => 0 }

  loop do
    board = initialize_board
    current_player = first_player

    loop do
      display_board(board)
      display_score(score)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)
    winner = detect_winner(board)
    display_winner(winner) if someone_won?(board)
    prompt "It's a tie!" if board_full?(board)

    keep_score(score, winner)
    display_score(score)
    break if grand_winner?(score) || !next_game?("Next round")
  end

  display_grand_winner?(score)

  break unless next_game?("Do you want to play a new match")
end

display_goodbye
