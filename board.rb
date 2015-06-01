class Board
  BOARD_SIZE = 9

  def initialize(number_of_mines)
    @number_of_mines = number_of_mines
    @rows = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE)}
  end

  def set_mines

  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, tile)
    @rows[x][y] = tile
  end

end
