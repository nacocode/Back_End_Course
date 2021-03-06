CHOICES = { "rock" => "r",
            "paper" => "p",
            "scissors" => "ss",
            "lizard" => "l",
            "spock" => "sp" }

def prompt(message)
  puts "=> #{message}"
end

def greeting
  prompt("Let's play a rock paper scissors spock lizard!\n
    When either you or computer wins five times, the match is over
    and the winning player becomes the Grand Winner. Ready?
    ")
end

def input_description
  prompt("Choose one >> type :\n
    'rock' or 'r' for 'rock'
    'paper' or 'p' for 'paper'
    'scissors' or 'ss' for 'scissors'
    'spock' or 'sp' for 'spock'
    'lizard' or 'l' for 'lizard'
    ")
end

def validate_player_choice(player_choice)
  loop do
    input_description

    player_choice = gets.downcase.chomp

    if CHOICES.keys.include?(player_choice)
      return player_choice
    elsif CHOICES.values.include?(player_choice)
      player_choice = CHOICES.key(player_choice)
      return player_choice
    else
      prompt("That's not a valid choice.")
    end
  end
end

def win?(first, second)
  win_condition = { "scissors" => ["paper", "lizard"],
                    "paper" => ["rock", "spock"],
                    "rock" => ["lizard", "scissors"],
                    "lizard" => ["spock", "paper"],
                    "spock" => ["scissors", "rock"] }

  win_condition[first].include?(second)
end

def display_results(player_choice, computer_choice)
  if player_choice == computer_choice
    prompt("It's a tie!")
  elsif win?(player_choice, computer_choice)
    prompt("You won!")
  else
    prompt("Computer won!")
  end
end

score = {
  "player" => 0,
  "computer" => 0
}

def keep_score(score, player_choice, computer_choice)
  if win?(player_choice, computer_choice)
    score["player"] += 1
  elsif win?(computer_choice, player_choice)
    score["computer"] += 1
  end

  prompt("<Scores>")
  score.each { |key, value| puts "   #{key}: #{value}" }
end

def grand_winner(score)
  if score.key(5) == "player"
    prompt("You won 5 times! Congratulations! You are the Grand Winner!!!")
  elsif score.key(5) == "computer"
    prompt("Computer won 5 times. Game over.")
  end
end

def continue?(continue_answer)
  loop do
    prompt("Do you want to play again?\n
   Type: 'yes' or 'no' (or 'y' or 'n')")
    continue_answer = gets.chomp.downcase
    if %w(yes y no n).include?(continue_answer)
      return continue_answer
    else
      prompt("Error: Invalid input. Try again.")
    end
  end
end

def clear_screen
  system("clear") || system("cls")
end

def good_bye
  prompt("Thank you for playing. Good bye!")
end

# _______________main___________________
greeting

loop do
  loop do
    player_choice = validate_player_choice(player_choice)

    computer_choice = CHOICES.keys.sample

    prompt("You chose : #{player_choice}
   Computer chose : #{computer_choice}")

    display_results(player_choice, computer_choice)

    keep_score(score, player_choice, computer_choice)

    break if score.value?(5)
  end

  grand_winner(score)

  continue_answer = continue?(continue_answer)

  break if continue_answer == "no" || continue_answer == "n"
  clear_screen if continue_answer == "yes" || continue_answer == "y"

  score["player"] = 0
  score["computer"] = 0
end

good_bye
