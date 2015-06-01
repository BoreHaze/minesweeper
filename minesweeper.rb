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


end
