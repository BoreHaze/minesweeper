require './tile.rb'
require './board.rb'
require 'byebug'

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
      coord = get_coordinate(move)

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

  def get_coordinate(move_type)
      valid_move = false
      until valid_move
        valid_move = true
        puts "Please choose a coordinate"
        coordinate = gets.chomp.split(",").map(&:to_i)
        #debugger
        if move_type == "r"
          valid_move = !@revealed_coords.include?(coordinate) &&
            @board.in_bounds?(coordinate) &&
            !@flagged_coords.include?(coordinate)
        else
          valid_move = !@revealed_coords.include?(coordinate) &&
            @board.in_bounds?(coordinate)
        end
        puts "Not a valid coordinate, try again." unless valid_move
      end

    coordinate
  end

  def won?
    @revealed_coords.sort == @board.safe_coords.sort
  end

  def lost?
    return false if @revealed_coords.empty?
    @board[*(@revealed_coords.last)].is_mine?
  end


end
