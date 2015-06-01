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
        reveal(coord)
      else
        if @flagged_coords.include?(coord)
          @flagged_coords.delete(coord)
        else
          @flagged_coords << coord
        end
      end

      draw_board

      break if lost?

    end

    puts "You lost!"

  end

  def draw_board
    puts "   0 1 2 3 4 5 6 7 8"
    horizontal_line = " +-#{'-'*Board::BOARD_SIZE*2}+"
    0.upto(Board::BOARD_SIZE - 1) do |row_idx|
      puts horizontal_line
      print "#{row_idx}| "
      0.upto(Board::BOARD_SIZE - 1) do |col_idx|

        tile = @board[row_idx, col_idx]

        if @revealed_coords.include?([row_idx, col_idx])

          if tile.is_mine?
           print "* "
          else
           print "#{tile.num_neighbors} "
          end

        elsif @flagged_coords.include?([row_idx, col_idx])
         print "F "
        else
         print "- "
        end

      end
      puts "|"
    end
    puts horizontal_line
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

  def reveal(coord)
    if @board[*coord].num_neighbors == 0
      explore_coords(coord)
    else
      @revealed_coords << coord
    end
  end

  def get_neighbors(coord)
    result = []
    Board::DELTAS.each do |d_x, d_y|
      check_coord = [coord.first + d_x, coord.last + d_y]
      next if @revealed_coords.include?(check_coord)
      result << check_coord if @board.in_bounds?(check_coord)
    end
    result
  end

  def explore_coords(coord)
    queue = [coord]
    until queue.empty?
      next_coord = queue.shift
      @revealed_coords << next_coord
      #debugger
      blank_neighbors = get_neighbors(next_coord)
      blank_neighbors.each do |explore_coord|
        if @board[*explore_coord].num_neighbors == 0
          queue << explore_coord
        else
          @revealed_coords << explore_coord
        end
      end
    end
  end

end
