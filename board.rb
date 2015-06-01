require './tile.rb'

class Board
  BOARD_SIZE = 9

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

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, tile)
    @rows[x][y] = tile
  end

end
