class Tile

  attr_accessor :num_neighbors

  def initialize(mine) #mine is a boolean
    @mine = mine
  end

  def inspect
    return "*" if @mine
    return @num_neighbors.to_s
  end

  def is_mine?
    @mine
  end

end
