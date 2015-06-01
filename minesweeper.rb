require './tile.rb'
require './board.rb'

class MineSweeper

  def initialize(board_size=9, number_of_mines=15)
    @board = Board.new(number_of_mines)
    @board.set_mines
    @board.set_numbers

    @flagged_coords  = []
    @revealed_coords = []
  end

  def play

    loop do
      move = get_move
      coord = get_coordinate

      if move == "r"
        #fill in adjacent blanks, add them to @revealed_coords
        @revealed_coords << coord
      else
        @flagged_coords << coord
      end

      #draw board

      break if lost?

    end

    puts "You lost!"

  end

  def get_move
    puts "Would you like to reveal or flag? (r/f)"
    selection = gets.chomp.downcase
    while selection != "r" && selection != "f"
      puts "Invalid input, would you like to reveal or flag? (r/f)"
      selection = gets.chomp.downcase
    end

    selection
  end

  def get_coordinate
    puts "Select a coordinate"
    coordinate = gets.chomp.split(",").map(&:to_i)
    until @board.in_bounds?(coordinate)
      puts "Invalid coordinate, select another coordinate"
      coordinate = gets.chomp.split(",").map(&:to_i)
    end

    coordinate
  end

  def won?
    @revealed_coords.sort == @board.safe_coords.sort
  end

  def lost?
    @board[*@revealed_coords.last].is_mine?
  end


end
