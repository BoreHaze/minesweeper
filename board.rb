require './tile.rb'

class Board
  BOARD_SIZE = 9
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

  def initialize(number_of_mines)
    @number_of_mines = number_of_mines
    @rows = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE)}
  end

  def set_mines
    @number_of_mines.times do

      placed_mine = false

      until placed_mine
        x = rand(BOARD_SIZE - 1)
        y = rand(BOARD_SIZE - 1)

        if self[x, y].nil?
          self[x, y] = Tile.new(true)
          placed_mine = true
        end
      end

    end
  end

  def set_numbers

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
    x.between?(0, BOARD_SIZE - 1) && y.between?(0, BOARD_SIZE - 1)
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, tile)
    @rows[x][y] = tile
  end

end
