class TicTacToe
  def initialize(board = nil)
    @board = board || Array.new(9, " ")
  end
# WIN_COMBINATIONS are in chronological order and based on index within @board
  WIN_COMBINATIONS = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]

# Checks if position is empty
  def position_taken?(location)
    !(@board[location].nil? || @board[location] == " " || @board[location] == "")
  end

  # Gets the @board and checks the turn. If the turn number is even, Player X goes, otherwise, Player O goes.
  def current_player()
    turn_count()%2 == 0 ? "X" : "O"
  end

  def display_board()
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} "
    puts "-----------"
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]} "
    puts "-----------"
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]} "
  end

  # Makes move by putting X or O in tile depending on current_player
  def move(location, current_player = "X")
    @board[location.to_i-1] = current_player
  end

  # Checks if the position given is valid and if empty
  def valid_move?(position)
    position.to_i.between?(1,9) && !position_taken?(position.to_i-1)
  end

  # Counts the number of Xs and Os on the @board to get number of turns
  def turn_count()
    number_turns = 0
    @board.each {|tile| (tile == "X" || tile == "O") ? (number_turns += 1) : ()}
    return number_turns
  end

  # Repeatedly asks the user to input a valid position. Once given function displays @board.
  def turn()
    puts "Please enter 1-9:"
    ARGV.clear
    input = gets.strip
    until valid_move?(input) == true
      puts "Please enter a number 1-9:"
      ARGV.clear
      input = gets.strip
    end

    move(input, current_player())
    display_board()
  end

  # Counts the number of Xs and Os on the @board and send back the current turn
  def full?()
    filled_tiles = 0
    @board.each { |tile| tile == "X" || tile == "O" ? (filled_tiles += 1) : ()}
    filled_tiles == 9 ?  (return true) : (return false)
  end

  # Finds all the indexes of X and O, then loops through each winning combination to see if either X or O's indexes match.
  # If the winning combination is found it is returned, otherwise false is returned.
  def won?()
    # Checks all tiles in @board and tracks the indexes where Xs and Os are
    x_indexes, o_indexes = [], []
    index = 0
    until index == 9
      @board[index] == "X" ? x_indexes.push(index) : (@board[index] == "O" ? (o_indexes.push(index)) : ())
      index += 1
    end

  # Checks each win_combination and selects the X or O indexes which match any of the win_combination indexes
  # If the matches include a win_combination, that combination is returned, otherwise false is returned.

    WIN_COMBINATIONS.each { |win_combination|
      if win_combination.all?{|n| x_indexes.include?(n)} == true
        return win_combination
      elsif win_combination.all? {|n| o_indexes.include?(n)} == true
        return win_combination
      end
    }

  # did not find a win_combination
    return false

  end

  # Draw if nobody wins and the @board is full
  def draw?()
    if won?() == true
      return false
    elsif full?() == false && won?() == false
      return false
    elsif full?() == true && won?() == false
      return true
    end

  end

  # Over if X or O won or they drawed
  def over?()
    won?().is_a?(Array) || draw?() == true ? (return true) : (return false)
  end

  # If someone won, function searches @board in first index returned from won?() function for the winner (X/O)
  # Returns nil otherwise
  def winner()
    won?().is_a?(Array) ? (return @board[won?()[0]]) : (return nil)
  end


  # Plays the game. 9 turns max
  def play()

    until over?() == true
      turn()

  # I added this to make the 'checks if the game is won after every turn' and 'checks if the game is draw after every turn' tests work. The tests in play_spec.rb always stopped at 'checks if the game is won after every turn' and would be in an infinite loop without this to break out of the loop.
      if winner() == "X" || winner() == "O"
        break
      end
    end

    if won?().is_a?(Array) == true
      puts "Congratulations #{winner()}!"
    elsif draw?() == true
      puts "Cats Game!"
    end
  end
end