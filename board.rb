require './tile.rb'
require './minesweeper.rb'

class Board
  DELTAS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ]

  attr_reader :number_of_mines, :flagged_coords, :revealed_coords

  def initialize(board_size = 9, number_of_mines)
    @number_of_mines = number_of_mines
    @rows = Array.new(board_size) { Array.new(board_size) }
    @flagged_coords  = []
    @revealed_coords = []
    @board_size = board_size
  end



  def set_mines
    mine_counter = 0
    until mine_counter == number_of_mines
      x = rand(@board_size - 1)
      y = rand(@board_size - 1)
      if self[x, y].nil?
        self[x, y] = Tile.new(true)
        mine_counter += 1
      end
    end
  end

  def set_numbers
    @rows.each_with_index do |row, x_index|
      row.each_with_index do |tile, y_index|
        next unless tile.nil?
        new_tile = Tile.new(false)
        new_tile.num_neighbors = count_adj_bombs([x_index, y_index])
        self[x_index, y_index] = new_tile
      end
    end
  end

  def count_adj_bombs(pos)
    counter = 0
    x, y = pos
    DELTAS.each do |d_x, d_y|
      next unless in_bounds?([x + d_x, y + d_y])
      next if self[x + d_x, y + d_y].nil?
      counter += 1 if self[x + d_x, y + d_y].is_mine?
    end
    counter
  end

  def in_bounds?(pos)
    x, y = pos
    return false if !x.is_a?(Fixnum) || !y.is_a?(Fixnum)
    x.between?(0, @board_size - 1) && y.between?(0, @board_size - 1)
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, tile)
    @rows[x][y] = tile
  end

  def draw_board
    print "  "
    @board_size.times do |i|
      print " #{i}"
    end
    puts ""

    0.upto(@board_size - 1) do |row_idx|
      render_rows(row_idx)
    end
    puts " +-#{'-'*@board_size*2}+"
  end

  def render_rows(row_idx)
    puts " +-#{'-'*@board_size*2}+"
    print "#{row_idx}| "
    0.upto(@board_size - 1) do |col_idx|
      render_tile(row_idx, col_idx)
    end
    puts "|"
  end

  def render_tile(row_idx, col_idx)
    tile = self[row_idx, col_idx]

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

  def won?
    @revealed_coords.count == (@board_size**2) - @number_of_mines
  end

  def lost?
    return false if @revealed_coords.empty?
    self[*(@revealed_coords.last)].is_mine?
  end

  def reveal(coord)
    if self[*coord].num_neighbors == 0
      explore_coords(coord)
    else
      @revealed_coords << coord
    end
  end

  def get_neighbors(coord)
    result = []
    DELTAS.each do |d_x, d_y|
      check_coord = [coord.first + d_x, coord.last + d_y]
      next if @revealed_coords.include?(check_coord)
      result << check_coord if in_bounds?(check_coord)
    end
    result
  end

  def explore_coords(coord)
    queue = [coord]
    @revealed_coords << coord
    until queue.empty?
      next_coord = queue.shift

      get_neighbors(next_coord).each do |explore_coord|
        @revealed_coords << explore_coord
        if self[*explore_coord].num_neighbors == 0
          queue << explore_coord
        end
      end
    end
  end

  def update(move, coord)
    if move == "r"
      reveal(coord)
    else
      if @flagged_coords.include?(coord)
        @flagged_coords.delete(coord)
      else
        @flagged_coords << coord
      end
    end
  end

end
